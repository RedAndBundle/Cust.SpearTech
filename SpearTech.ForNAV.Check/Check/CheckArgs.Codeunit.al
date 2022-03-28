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

    procedure SetMergedCheck(var os: OutStream)
    var
        is: InStream;
    begin
        MergedCheck.CreateInStream(is);
        CopyStream(os, is);
    end;

    procedure GetMergedCheck() is: InStream
    begin
        MergedCheck.CreateInstream(is);
    end;

    var
        Args: Record "ForNAV Check Arguments" temporary;
        MergedCheck: Codeunit "Temp Blob";
}