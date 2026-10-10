# LLDB formatters for ZeroEngine containers, so codelldb shows their elements.
# Loaded by the codelldb launch config in Neovim's dap.lua:
#     command script import "<path>/ZeroFormatters.py"
#
# TArray<T>:          T* Elements; int32 Count; int32 Capacity
# TFixedArray<T, N>:  TStaticArray<T, N> Elements; int32 Count
#
# One-line summaries for the maths and colour types, so they read as values:
# FVector2D (3, 4.5)   FScreenPos (512, 300) px   FIntPoint2D (2, 7)
# FTileCoord tile (2, 7) level 0   FColour RGBA(135, 206, 250, 180)

import lldb

MAX_SHOWN = 10000  # never ask the debugger for more children than this


def _clamp(Value, Low, High):
    return max(Low, min(Value, High))


class _ArrayProviderBase:
    def __init__(self, valobj, internal_dict):
        self.valobj = valobj
        self.count = 0
        self.base_address = 0
        self.element_type = None
        self.element_size = 0

    def num_children(self):
        return self.count

    def get_child_index(self, name):
        try:
            return int(name.lstrip("[").rstrip("]"))
        except ValueError:
            return -1

    def get_child_at_index(self, index):
        if index < 0 or index >= self.count or self.element_type is None:
            return None
        address = self.base_address + index * self.element_size
        return self.valobj.CreateValueFromAddress("[%d]" % index, address, self.element_type)

    def has_children(self):
        return True


class TArrayProvider(_ArrayProviderBase):
    def update(self):
        self.count = 0
        elements = self.valobj.GetChildMemberWithName("Elements")
        count = self.valobj.GetChildMemberWithName("Count").GetValueAsSigned(0)
        capacity = self.valobj.GetChildMemberWithName("Capacity").GetValueAsSigned(0)
        if not elements.IsValid() or elements.GetValueAsUnsigned(0) == 0:
            return False
        self.element_type = elements.GetType().GetPointeeType()
        self.element_size = self.element_type.GetByteSize()
        self.base_address = elements.GetValueAsUnsigned(0)
        # A garbage Count, from an uninitialised array, must not hang the debugger.
        self.count = _clamp(count, 0, min(capacity, MAX_SHOWN))
        return False


class TFixedArrayProvider(_ArrayProviderBase):
    def update(self):
        self.count = 0
        elements = self.valobj.GetChildMemberWithName("Elements").GetNonSyntheticValue()
        count = self.valobj.GetChildMemberWithName("Count").GetValueAsSigned(0)
        # std::array has one member on every standard library: the plain C array.
        storage = elements.GetChildAtIndex(0).GetNonSyntheticValue()
        if not storage.IsValid() or not storage.GetType().IsArrayType():
            return False
        self.element_type = storage.GetType().GetArrayElementType()
        self.element_size = self.element_type.GetByteSize()
        self.base_address = storage.GetLoadAddress()
        capacity = storage.GetType().GetByteSize() // max(self.element_size, 1)
        self.count = _clamp(count, 0, min(capacity, MAX_SHOWN))
        return False


def _summary(valobj, internal_dict, has_capacity_member):
    raw = valobj.GetNonSyntheticValue()
    count = raw.GetChildMemberWithName("Count").GetValueAsSigned(0)
    if has_capacity_member:
        capacity = raw.GetChildMemberWithName("Capacity").GetValueAsSigned(0)
        return "Count=%d Capacity=%d" % (count, capacity)
    return "Count=%d" % count


def TArraySummary(valobj, internal_dict):
    return _summary(valobj, internal_dict, True)


def TFixedArraySummary(valobj, internal_dict):
    return _summary(valobj, internal_dict, False)


# ----- Maths and colour types -----


def _number(Value):
    # Up to 3 decimals, trailing zeros dropped: 3, 4.5, 0.125
    return ("%.3f" % Value).rstrip("0").rstrip(".")


def _float_member(valobj, name):
    try:
        return float(valobj.GetChildMemberWithName(name).GetValue())
    except (TypeError, ValueError):
        return float("nan")


def _int_member(valobj, name):
    return valobj.GetChildMemberWithName(name).GetValueAsSigned(0)


def _vector_text(valobj):
    return "(%s, %s)" % (_number(_float_member(valobj, "X")), _number(_float_member(valobj, "Y")))


def _int_point_text(valobj):
    return "(%d, %d)" % (_int_member(valobj, "X"), _int_member(valobj, "Y"))


def FVector2DSummary(valobj, internal_dict):
    return _vector_text(valobj.GetNonSyntheticValue())


def FScreenPosSummary(valobj, internal_dict):
    return _vector_text(valobj.GetNonSyntheticValue().GetChildMemberWithName("Pixels")) + " px"


def FIntPoint2DSummary(valobj, internal_dict):
    return _int_point_text(valobj.GetNonSyntheticValue())


def FTileCoordSummary(valobj, internal_dict):
    raw = valobj.GetNonSyntheticValue()
    return "tile %s level %d" % (_int_point_text(raw.GetChildMemberWithName("Tile")), _int_member(raw, "Level"))


def FColourSummary(valobj, internal_dict):
    raw = valobj.GetNonSyntheticValue()
    channels = [raw.GetChildMemberWithName(name).GetValueAsUnsigned(0) for name in ("R", "G", "B", "A")]
    return "RGBA(%d, %d, %d, %d)" % tuple(channels)


def __lldb_init_module(debugger, internal_dict):
    module = __name__
    for type_regex, provider, summary in (
        ("^TArray<.+>$", "TArrayProvider", "TArraySummary"),
        ("^TFixedArray<.+>$", "TFixedArrayProvider", "TFixedArraySummary"),
    ):
        debugger.HandleCommand('type synthetic add -x "%s" -l %s.%s' % (type_regex, module, provider))
        debugger.HandleCommand('type summary add -x "%s" -F %s.%s -e' % (type_regex, module, summary))

    # Summaries only: the members can still be expanded underneath
    for type_regex, summary in (
        ("^FVector2D$", "FVector2DSummary"),
        ("^FScreenPos$", "FScreenPosSummary"),
        ("^FIntPoint2D$", "FIntPoint2DSummary"),
        ("^FTileCoord$", "FTileCoordSummary"),
        ("^(Zero::)?FColour$", "FColourSummary"),
    ):
        debugger.HandleCommand('type summary add -x "%s" -F %s.%s' % (type_regex, module, summary))
