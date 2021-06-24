codeunit 50102 "PTE Run Check Report"
{

    internal procedure RunCheckReportPerLine(var Args: Record "ForNAV Check Arguments"; var GenJnlLn: Record "Gen. Journal Line")
    var
        Check: Report "PTE US Check";
        GenJnlLnFilter: Record "Gen. Journal Line";
    begin
        GenJnlLn.FindSet();
        repeat
            Args."PTE Document No." := GenJnlLn."Document No.";
            Check.SetArgs(Args);
            GenJnlLnFilter.Get(GenJnlLn.RecordId);
            GenJnlLnFilter.SetRecFilter();
            Check.Run();
        until GenJnlLn.Next() = 0;
    end;

}