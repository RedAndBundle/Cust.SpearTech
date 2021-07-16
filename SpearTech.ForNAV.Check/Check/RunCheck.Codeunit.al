codeunit 50102 "PTE Run Check Report"
{

    internal procedure RunCheckReportPerLine(var Args: Record "ForNAV Check Arguments"; var GenJnlLn: Record "Gen. Journal Line")
    begin
        GenJnlLn.FindSet();
        repeat
            ProcessCheck(Args, GenJnlLn)
        until GenJnlLn.Next() = 0;
    end;

    local procedure ProcessCheck(var Args: Record "ForNAV Check Arguments"; GenJnlLn: Record "Gen. Journal Line")
    var
        TempBlob: Record "ForNAV Core Setup";
        GenJnlLnFilter: Record "Gen. Journal Line";
        CheckArgs: Codeunit "PTE Check Args";
        Filename, Parameters : Text;
        OutStr: OutStream;
        InStr: InStream;
        GenJnlLnRef: RecordRef;
    begin
        GenJnlLnFilter.Get(GenJnlLn.RecordId);
        GenJnlLnFilter.SetRecFilter();
        Args."PTE Document No." := GenJnlLn."Applies-to Doc. No.";
        CheckArgs.SetArgs(Args);
        GenJnlLnRef.GetTable(GenJnlLnFilter);

        case Args."PTE Output Type" of
            Args."PTE Output Type"::PDF:
                begin
                    // TODO store in zip file and offer that for download.
                    TempBlob.Blob.CreateOutstream(OutStr);
                    TempBlob.Blob.CreateInstream(InStr);
                    Report.SaveAs(Report::"PTE US Check", Parameters, ReportFormat::Pdf, OutStr, GenJnlLnRef);
                    Filename := Args."PTE Document No." + '.pdf';
                    DownloadFromStream(InStr, '', '', '', Filename);
                end;
            Args."PTE Output Type"::Print:
                Report.Print(Report::"PTE US Check", Parameters, '', GenJnlLnRef);
        end;

        CheckArgs.Reset();

        if not Args."Test Print" then
            DeletePDF(Args."PTE Document No.");
    end;

    local procedure DeletePDF(Value: Code[20])
    var
        PDFFile: Record "ForNAV File Storage";
    begin
        if PDFFile.Get(Value) then
            PDFFile.Delete();
    end;

}