from typing import Dict, Type, Any, Optional

from library.exceptions import ValidationError, FieldReadError


class BaseColumnType:
    """Base type for custom columns type."""
    def __init__(self, min_value: Optional[Any] = None, max_value: Optional[Any] = None):
        self.min = min_value
        self.max = max_value

    def validate(self, value):
        """Override for validation."""
        raise NotImplementedError()


class Int(BaseColumnType):
    def validate(self, value):
        if not isinstance(value, int) and value is not None:
            raise ValidationError(self.__class__.__name__)


class Str(BaseColumnType):
    def validate(self, value):
        if not isinstance(value, str) and value is not None:
            raise ValidationError(self.__class__.__name__)


class Char(BaseColumnType):
    def validate(self, value):
        if (not isinstance(value, str) or len(value) > 1) and value is not None:
            raise ValidationError(self.__class__.__name__)


class Float(BaseColumnType):
    def validate(self, value):
        if not isinstance(value, float) and value is not None:
            raise ValidationError(self.__class__.__name__)


class Money(Str):
    def validate(self, value):
        from re import match
        super().validate(value)
        if value is None:
            raise ValidationError(self.__class__.__name__)
        if not match(r'^\$\d{,14}.?\d{,2}$', value) or float(value[1:]) >= 10000000000000.00:
            raise ValidationError(self.__class__.__name__)



class MoneyInvl(Money):
    def validate(self, value):
        super().validate(value)
        if value is not None and not self.min <= float(value[1:]) <= self.max:
            raise ValidationError(self.__class__.__name__)


# for db from file load
all_types: Dict[str, Type[BaseColumnType]] = {
    Float.__name__: Float,
    Char.__name__: Char,
    Str.__name__: Str,
    Int.__name__: Int,
    Money.__name__: Money,
    MoneyInvl.__name__: MoneyInvl,
}

types_hack = {
    Float.__name__: float,
    Char.__name__: str,
    Str.__name__: str,
    Int.__name__: int,
    Money.__name__: str,
    MoneyInvl.__name__: str,
}
