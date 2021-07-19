codeunit 80401 "PTE Check Args"
{
    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    procedure SetArgs(var NewArgs: Record "ForNAV Check Arguments")
    begin
        Args.DeleteAll();
        Args := NewArgs;
        Args.Insert();
    end;

    procedure GetArgs() Result: Record "ForNAV Check Arguments"
    begin
        exit(Args);
    end;

    procedure Reset()
    begin
        Args.DeleteAll();
    end;

    var
        Args: Record "ForNAV Check Arguments" temporary;
}