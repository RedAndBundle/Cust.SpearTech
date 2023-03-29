codeunit 80402 "PTE Run Check Report"
{
    Permissions = tabledata "PTE Check Data" = rimd;

    internal procedure RunCheckReportPerLine(var Args: Record "ForNAV Check Arguments"; var GenJnlLn: Record "Gen. Journal Line")
    var
        Setup: Record "PTE Spear Technology Setup";
        TempMergePDF: Record "PTE PDF Merge File" temporary;
        CheckArgs: Codeunit "PTE Check Args";
    begin
        // CheckArgs.ResetMergedCheck();
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
        // CheckArgs.Reset();
    end;

    local procedure ProcessCheck(var Args: Record "ForNAV Check Arguments"; GenJnlLn: Record "Gen. Journal Line"; var TempMergePDF: Record "PTE PDF Merge File" temporary)
    var
        GenJnlLnFilter: Record "Gen. Journal Line";
        Setup: Record "PTE Spear Technology Setup";
        CheckArgs: Codeunit "PTE Check Args";
        Filename, Parameters : Text;
        OutStr: OutStream;
        InStr: InStream;
        GenJnlLnRef: RecordRef;
    begin
        Setup.Get();
        GenJnlLnFilter.Get(GenJnlLn.RecordId);
        GenJnlLnFilter.SetRecFilter();
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
                    TempMergePDF.Insert();
                    // if Setup."Output Type" = Setup."Output Type"::PDF then
                    //     CheckArgs.SetMergedCheck(TempMergePDF);
                end;
            Args."PTE Output Type"::Print:
                Report.Print(Report::"PTE US Check", Parameters, '', GenJnlLnRef);
        end;

        CheckArgs.Reset();
    end;
}