codeunit 80402 "PTE Run Check Report"
{
    Permissions = tabledata "PTE Check Data" = rimd;

    internal procedure RunCheckReportPerBatch(var Args: Record "ForNAV Check Arguments"; var GenJournalBatch: Record "Gen. Journal Batch"; var MergePDF: Record "PTE PDF Merge File")
    var
        GenJnlLn: Record "Gen. Journal Line";
    begin
        GenJnlLn.SetRange("Journal Template Name", GenJournalBatch."Journal Template Name");
        GenJnlLn.SetRange("Journal Batch Name", GenJournalBatch.Name);

        if Args."Reprint Checks" then
            VoidChecks(Args, GenJnlLn);

        if GenJnlLn.FindSet() then
            repeat
                ProcessCheck(Args, GenJnlLn, MergePDF);
                Args.GetNextCheckNo();
            until GenJnlLn.Next() = 0;
    end;

    local procedure VoidChecks(var Args: Record "ForNAV Check Arguments"; var GenJnlLn: Record "Gen. Journal Line")
    var
        VoidGenJnlLn: Record "Gen. Journal Line";
        CheckManagement: Codeunit CheckManagement;
        TestVoidCheck: Codeunit "ForNAV Test Void Check";
    begin
        VoidGenJnlLn.CopyFilters(GenJnlLn);
        VoidGenJnlLn.SetFilter("Bal. Account No.", '%1|%2', '', Args."Bank Account No.");
        if TestVoidCheck.TestVoidCheck(VoidGenJnlLn, Args, false) then
            if VoidGenJnlLn.FindSet() then
                repeat
                    CheckManagement.VoidCheck(VoidGenJnlLn);
                until VoidGenJnlLn.Next() = 0;

        Args."Reprint Checks" := false;
        Args.Modify();
    end;

    internal procedure RunCheckReportPerLine(var Args: Record "ForNAV Check Arguments"; var GenJnlLn: Record "Gen. Journal Line")
    var
        Setup: Record "PTE Spear Technology Setup";
        TempMergePDF: Record "PTE PDF Merge File" temporary;
    begin
        Setup.Get();
        Setup.TestPDFSetup();
        GenJnlLn.FindSet();
        repeat
            ProcessCheck(Args, GenJnlLn, TempMergePDF);
            Args.GetNextCheckNo();
        until GenJnlLn.Next() = 0;

        case Setup."Output Type" of
            Setup."Output Type"::Zip:
                TempMergePDF.Zip();
            Setup."Output Type"::PDF:
                TempMergePDF.MergeAndPreview();
        end;
    end;

    local procedure ProcessCheck(var Args: Record "ForNAV Check Arguments"; GenJnlLn: Record "Gen. Journal Line"; var TempMergePDF: Record "PTE PDF Merge File" temporary)
    var
        GenJnlLnFilter: Record "Gen. Journal Line";
        Setup: Record "PTE Spear Technology Setup";
        CheckArgs: Codeunit "PTE Check Args";
        GenJnlLnRef: RecordRef;
        Parameters: Text;
        OutStr: OutStream;
        InStr: InStream;
    begin
        Setup.Get();
        GenJnlLnFilter.Get(GenJnlLn.RecordId);
        GenJnlLnFilter.SetRecFilter();
        if GenJnlLn."Applies-to ID" <> '' then
            Args.Validate("PTE Applies-to ID", GenJnlLn."Applies-to ID")
        else
            Args."PTE Document No." := GenJnlLn."Applies-to Doc. No.";

        CheckArgs.SetArgs(Args);
        GenJnlLnRef.GetTable(GenJnlLnFilter);

        case Args."PTE Output Type" of
            Args."PTE Output Type"::PDF:
                begin
                    if Args."PTE Document No." = '' then
                        TempMergePDF."Primary Key" := Format(GenJnlLn."Line No.")
                    else
                        TempMergePDF."Primary Key" := Args."PTE Document No.";
                    TempMergePDF.Blob.CreateOutstream(OutStr);
                    TempMergePDF.Blob.CreateInstream(InStr);
                    Report.SaveAs(Report::"PTE US Check", Parameters, ReportFormat::Pdf, OutStr, GenJnlLnRef);
                    TempMergePDF.Filename := Args."PTE Document No." + '.pdf';
                    if TempMergePDF.Blob.Length > 0 then
                        TempMergePDF.Insert();
                end;
            Args."PTE Output Type"::Print:
                Report.Print(Report::"PTE US Check", Parameters, '', GenJnlLnRef);
        end;

        CheckArgs.Reset();
    end;
}