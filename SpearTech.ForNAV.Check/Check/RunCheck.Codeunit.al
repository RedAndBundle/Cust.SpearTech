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
        Setup.TestReportSelection();
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

    local procedure ProcessCheck(var Args: Record "ForNAV Check Arguments"; var GenJnlLn: Record "Gen. Journal Line"; var TempMergePDF: Record "PTE PDF Merge File" temporary)
    var
        GenJnlLnFilter: Record "Gen. Journal Line";
        ReportSelections: Record "Report Selections";
        Setup: Record "PTE Spear Technology Setup";
        TempBlob: Codeunit "Temp Blob";
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
                    if TempMergePDF."Primary Key" = '' then
                        TempMergePDF."Primary Key" := '00000001'
                    else
                        TempMergePDF."Primary Key" := IncStr(TempMergePDF."Primary Key");

                    TempMergePDF.Blob.CreateOutstream(OutStr);
                    ReportSelections.SetRange(Usage, ReportSelections.Usage::"PTE Spear Check");
                    ReportSelections.FindFirst();

                    ReportSelections.SaveReportAsPDFInTempBlob(TempBlob, ReportSelections."Report ID", GenJnlLnRef, GetLayoutCode(ReportSelections."Report ID"), ReportSelections.Usage);
                    TempBlob.CreateInstream(InStr);
                    CopyStream(OutStr, InStr);
                    if Args."PTE Document No." = '' then
                        TempMergePDF.Filename := Format(GenJnlLn."Line No.") + '.pdf'
                    else
                        TempMergePDF.Filename := Args."PTE Document No." + '.pdf';

                    if TempMergePDF.Blob.Length > 0 then
                        TempMergePDF.Insert();
                end;
            Args."PTE Output Type"::Print:
                Report.Print(Report::"PTE US Check", Parameters, '', GenJnlLnRef);
        end;

        CheckArgs.Reset();
    end;

    local procedure GetLayoutCode(ReportId: Integer) CustomReportLayoutCode: Text
    var
        ReportLayoutSelection: Record "Report Layout Selection";
    begin
        case true of
            ReportLayoutSelection.Get(ReportId, CompanyName):
                CustomReportLayoutCode := ReportLayoutSelection."Custom Report Layout Code";
            ReportLayoutSelection.Get(ReportId, ''):
                CustomReportLayoutCode := ReportLayoutSelection."Custom Report Layout Code";
        end;
    end;

    local procedure FilterOneCheckPerVendorPerDocument(var GenJournalLine: Record "Gen. Journal Line"; var FromGenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine.Reset();
        GenJournalLine.SetCurrentkey("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
        GenJournalLine.SetRange("Journal Template Name", FromGenJournalLine."Journal Template Name");
        GenJournalLine.SetRange("Journal Batch Name", FromGenJournalLine."Journal Batch Name");
        GenJournalLine.SetRange("Posting Date", FromGenJournalLine."Posting Date");
        GenJournalLine.SetRange("Document No.", FromGenJournalLine."Document No.");
        GenJournalLine.SetRange("Account Type", FromGenJournalLine."Account Type");
        GenJournalLine.SetRange("Account No.", FromGenJournalLine."Account No.");
        GenJournalLine.SetRange("Bal. Account Type", FromGenJournalLine."Bal. Account Type");
        GenJournalLine.SetRange("Bal. Account No.", FromGenJournalLine."Bal. Account No.");
        GenJournalLine.SetRange("Bank Payment Type", FromGenJournalLine."Bank Payment Type");
        GenJournalLine.CalcSums(Amount);
    end;
}