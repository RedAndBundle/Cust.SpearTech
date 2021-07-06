codeunit 50102 "PTE Run Check Report"
{

    internal procedure RunCheckReportPerLine(var Args: Record "ForNAV Check Arguments"; var GenJnlLn: Record "Gen. Journal Line")
    var
    begin
        GenJnlLn.FindSet();
        repeat
            ProcessCheck(Args, GenJnlLn)
        until GenJnlLn.Next() = 0;
    end;

    local procedure ProcessCheck(var Args: Record "ForNAV Check Arguments"; GenJnlLn: Record "Gen. Journal Line")
    var
        TempBlob: Record "ForNAV Core Setup";
        Check: Report "PTE US Check";
        GenJnlLnFilter: Record "Gen. Journal Line";
        Filename, Parameters : Text;
        OutStr: OutStream;
        InStr: InStream;
        ArgsRef: RecordRef;
        GenJnlLnRef: RecordRef;
    begin
        // Check.SetArgs(Args);
        GenJnlLnFilter.Get(GenJnlLn.RecordId);
        GenJnlLnFilter.SetRecFilter();
        TempBlob.Blob.CreateOutstream(OutStr);
        TempBlob.Blob.CreateInstream(InStr);
        // Check.SetTableView(GenJnlLnFilter);
        // Check.InputBankAccount;
        Args."PTE Document No." := GenJnlLn."Applies-to Doc. No.";
        Args."PTE GL Entry" := GenJnlLnFilter.RecordId;
        // TODO Args set bank acc
        ArgsRef.GetTable(Args);
        Report.Print(Report::"PTE US Check", Parameters, '', ArgsRef);

        // Check.SaveAs(Parameters, Reportformat::Pdf, OutStr);
        // Filename := Args."PTE Document No." + '.pdf';
        // DownloadFromStream(InStr, '', '', '', Filename);
        if not Args."Test Print" then
            DeletePDF(Args."PTE Document No.");
    end;

    local procedure DeletePDF(Value: Code[20])
    var
        PDFFile: Record "ForNAV File Storage";
    begin
        PDFFile.Get(Value);
        PDFFile.Delete();
    end;

}