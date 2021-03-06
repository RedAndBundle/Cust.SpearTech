codeunit 80402 "PTE Run Check Report"
{

    internal procedure RunCheckReportPerLine(var Args: Record "ForNAV Check Arguments"; var GenJnlLn: Record "Gen. Journal Line")
    var
        TempMergePDF: Record "PTE PDF Merge" temporary;
    begin
        GenJnlLn.FindSet();
        repeat
            ProcessCheck(Args, GenJnlLn, TempMergePDF)
        until GenJnlLn.Next() = 0;

        case Args."PTE Output Type" of
            Args."PTE Output Type"::Zip:
                TempMergePDF.Zip();
            Args."PTE Output Type"::PDF:
                TempMergePDF.MergeAndPreview();
        end;
    end;

    local procedure ProcessCheck(var Args: Record "ForNAV Check Arguments"; GenJnlLn: Record "Gen. Journal Line"; var TempMergePDF: Record "PTE PDF Merge" temporary)
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
            Args."PTE Output Type"::PDF, Args."PTE Output Type"::Zip:
                begin
                    TempMergePDF."Primary Key" := Args."PTE Document No.";
                    TempMergePDF.Blob.CreateOutstream(OutStr);
                    TempMergePDF.Blob.CreateInstream(InStr);
                    Report.SaveAs(Report::"PTE US Check", Parameters, ReportFormat::Pdf, OutStr, GenJnlLnRef);
                    TempMergePDF.Filename := Args."PTE Document No." + '.pdf';
                    TempMergePDF.Insert();
                    if Setup."Output Type" = Setup."Output Type"::PDF then
                        CheckArgs.SetMergedCheck(TempMergePDF);
                end;
            Args."PTE Output Type"::Print:
                Report.Print(Report::"PTE US Check", Parameters, '', GenJnlLnRef);
        end;

        CheckArgs.Reset();
    end;

}