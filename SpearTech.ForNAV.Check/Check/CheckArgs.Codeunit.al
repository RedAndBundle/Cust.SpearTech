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

    // procedure SetMergedCheck(var TempBlobIn: Record "PTE PDF Merge File")
    // begin
    //     TempBlob := TempBlobIn;
    //     TempBlob.Blob := TempBlobIn.Blob;
    //     if not TempBlob.Insert() then
    //         TempBlob.Modify();
    // end;

    // procedure GetMergedCheck(var is: InStream): Boolean
    // begin
    //     TempBlob.CalcFields(Blob);
    //     if not TempBlob.Blob.HasValue() then
    //         exit(false);

    //     TempBlob.Blob.CreateInStream(is);
    //     exit(not TempBlob.IsEmpty);
    // end;

    // procedure ResetMergedCheck()
    // begin
    //     // clear(TempBlob.Blob);
    //     if TempBlob.Delete() then;
    // end;

    var
        Args: Record "ForNAV Check Arguments" temporary;
    // TempBlob: Record "PTE PDF Merge File" temporary;
}