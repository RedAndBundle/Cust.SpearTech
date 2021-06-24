codeunit 50102 "PTE Run Check Report"
{

    internal procedure RunCheckReportPerLine(var Args: Record "ForNAV Check Arguments"; var GenJnlLn: Record "Gen. Journal Line")
    var
        TempBlob: Record "ForNAV Core Setup";
        Check: Report "PTE US Check";
        GenJnlLnFilter: Record "Gen. Journal Line";
        Filename, Parameters : Text;
        OutStr: OutStream;
        InStr: InStream;
    begin
        GenJnlLn.FindSet();
        repeat
            Args."Test Print" := true;
            Args."PTE Document No." := GenJnlLn."Applies-to Doc. No.";
            Check.SetArgs(Args);
            GenJnlLnFilter.Get(GenJnlLn.RecordId);
            GenJnlLnFilter.SetRecFilter();
            TempBlob.Blob.CreateOutstream(OutStr);
            TempBlob.Blob.CreateInstream(InStr);
            Check.SetArgs(Args);
            Check.SetTableView(GenJnlLn);
            Check.InputBankAccount;
            Check.SaveAs(Parameters, Reportformat::Pdf, OutStr);
            Filename := Args."PTE Document No." + '.pdf';
            DownloadFromStream(InStr, '', '', '', Filename);
            DeletePDF(Args."PTE Document No.");
        until GenJnlLn.Next() = 0;
    end;

    local procedure DeletePDF(Value: Code[20])
    var
        PDFFile: Record "ForNAV File Storage";
    begin
        PDFFile.Get(Value);
        PDFFile.Delete();
    end;

}