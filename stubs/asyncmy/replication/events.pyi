"""
This type stub file was generated by pyright.
"""

class BinLogEvent:
    def __init__(
        self,
        from_packet,
        event_size,
        table_map,
        connection,
        only_tables=...,
        ignored_tables=...,
        only_schemas=...,
        ignored_schemas=...,
        freeze_schema=...,
        fail_on_table_metadata_unavailable=...,
    ) -> None: ...
    @property
    def processed(self):  # -> bool:
        ...
    async def init(self):  # -> None:
        ...

class GtidEvent(BinLogEvent):
    """GTID change in binlog event"""

    def __init__(
        self, from_packet, event_size, table_map, ctl_connection, **kwargs
    ) -> None: ...
    @property
    def gtid(self):  # -> str:
        """GTID = source_id:transaction_id
        Eg: 3E11FA47-71CA-11E1-9E33-C80AA9429562:23
        See: http://dev.mysql.com/doc/refman/5.6/en/replication-gtids-concepts.html"""
        ...

class RotateEvent(BinLogEvent):
    """Change MySQL bin log file

    Attributes:
        position: Position inside next binlog
        next_binlog: Name of next binlog file
    """

    def __init__(
        self, from_packet, event_size, table_map, ctl_connection, **kwargs
    ) -> None: ...

class FormatDescriptionEvent(BinLogEvent): ...
class StopEvent(BinLogEvent): ...

class XidEvent(BinLogEvent):
    """A COMMIT event

    Attributes:
        xid: Transaction ID for 2PC
    """

    def __init__(
        self, from_packet, event_size, table_map, ctl_connection, **kwargs
    ) -> None: ...

class HeartbeatLogEvent(BinLogEvent):
    def __init__(
        self, from_packet, event_size, table_map, ctl_connection, **kwargs
    ) -> None: ...

class QueryEvent(BinLogEvent):
    """This evenement is trigger when a query is run of the database.
    Only replicated queries are logged."""

    def __init__(
        self, from_packet, event_size, table_map, ctl_connection, **kwargs
    ) -> None: ...

class BeginLoadQueryEvent(BinLogEvent):
    """

    Attributes:
        file_id
        block-data
    """

    def __init__(
        self, from_packet, event_size, table_map, ctl_connection, **kwargs
    ) -> None: ...

class ExecuteLoadQueryEvent(BinLogEvent):
    """

    Attributes:
        slave_proxy_id
        execution_time
        schema_length
        error_code
        status_vars_length

        file_id
        start_pos
        end_pos
        dup_handling_flags
    """

    def __init__(
        self, from_packet, event_size, table_map, ctl_connection, **kwargs
    ) -> None: ...

class IntvarEvent(BinLogEvent):
    """

    Attributes:
        type
        value
    """

    def __init__(
        self, from_packet, event_size, table_map, ctl_connection, **kwargs
    ) -> None: ...

class NotImplementedEvent(BinLogEvent):
    def __init__(
        self, from_packet, event_size, table_map, ctl_connection, **kwargs
    ) -> None: ...
