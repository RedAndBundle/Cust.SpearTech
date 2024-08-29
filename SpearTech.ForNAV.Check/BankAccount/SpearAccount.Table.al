table 80405 "PTE Spear Account"
{
    DataClassification = CustomerContent;
    Caption = 'Spear Account';
    fields
    {
        field(1; "Spear Account No."; Text[30]) { }
        field(10; "Last Check No."; Code[20]) { }
    }

    keys
    {
        key(PK; "Spear Account No.") { Clustered = true; }
    }

    procedure FindBankAccountNumbers()
    var
        BankAccount: Record "Bank Account";
    begin
        BankAccount.SetFilter("Bank Account No.", '<>%1', '');
        if BankAccount.FindSet() then
            repeat
                Rec.SetRange("Spear Account No.", BankAccount."Bank Account No.");
                if not Rec.FindFirst() then begin
                    Rec."Spear Account No." := BankAccount."Bank Account No.";
                    Rec.Insert();
                end;
            until BankAccount.Next() = 0;
    end;
}