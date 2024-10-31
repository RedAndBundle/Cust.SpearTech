codeunit 80406 "PTE Check No."
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ForNAV Check Update Journal", OnBeforeUpdateBankAccountCheckNumber, '', false, false)]
    local procedure OnBeforeUpdateBankAccountCheckNumber(BankAccountNo: Code[20]; CheckNo: Code[20]; var IsHandled: Boolean)
    begin
        UpdateGlobalLastCheckNo(BankAccountNo, CheckNo);
    end;

    local procedure UpdateGlobalLastCheckNo(BankAccountNo: Code[20]; CheckNo: Code[20])
    var
        BankAccount: Record "Bank Account";
        SpearAccount: Record "PTE Spear Account";
    begin
        BankAccount.Get(BankAccountNo);
        if SpearAccount.Get(BankAccount."Bank Account No.") then
            if SpearAccount."Last Check No." <> '' then begin
                SpearAccount."Last Check No." := CheckNo;
                SpearAccount.Modify();
            end;
    end;
}