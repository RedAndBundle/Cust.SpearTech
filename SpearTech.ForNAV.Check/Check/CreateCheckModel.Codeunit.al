codeunit 80407 "PTE Create Check Model"
{
    procedure CreateFromGenJnlLn(var Args: Record "ForNAV Check Arguments"; var GenJnlLn: Record "Gen. Journal Line"; var Model: Record "ForNAV Check Model"): Boolean
    var
        TempCheck: Record "ForNAV Check" temporary;
        TempStub: Record "ForNAV Stub" temporary;
        ForNAVCreateCheckModel: Codeunit "ForNAV Create Check Model";
    begin
        if not ValidLine(Args, GenJnlLn, Model) then
            exit(false);

        Clear(Model);

        if not Args."Test Print" then
            GenJnlLn.TestField(Amount);

        TempCheck.CreateFromGenJnlLn(Args, GenJnlLn);
        TempCheck.GetStub(Args, TempStub, GenJnlLn);
        TempCheck.UpdateJournal(Args, GenJnlLn);
        TempCheck.CreateCheckLedgerEntry(Args, GenJnlLn);
        ForNAVCreateCheckModel.CreateModel(TempCheck, TempStub, Model);
        IncreaseCheckNoIfMultiplePages(Args, Model."No. of Pages");
        exit(true);
    end;

    local procedure ValidLine(var Args: Record "ForNAV Check Arguments"; var GenJnlLn: Record "Gen. Journal Line"; var Model: Record "ForNAV Check Model"): Boolean
    begin
        if not Args."One Check Per Vendor" then
            exit(true);

        if not Model.FindFirst() then
            exit(true);

        exit(GenJnlLn."Account No." <> Model."Pay-to Vendor No.");
    end;

    procedure IncreaseCheckNoIfMultiplePages(var Args: Record "ForNAV Check Arguments"; NoOfPages: Integer)
    var
        Setup: Record "PTE Spear Technology Setup";
        CheckUpdateJournal: Codeunit "ForNAV Check Update Journal";
        i: Integer;
    begin
        if NoOfPages <= 1 then
            exit;

        Setup.Get();

        if Setup."One Check No Per Check" then
            exit;

        for i := 2 to NoOfPages do
            Args."Check No." := IncStr(Args."Check No.");

        CheckUpdateJournal.UpdateBankAccountCheckNumber(Args."Bank Account No.", Args."Check No.");
    end;
}