table 80403 "PTE Void Interface"
{
    DataClassification = SystemMetadata;
    TableType = Temporary;

    fields
    {
        field(1; "Vendor No."; Code[20]) { DataClassification = SystemMetadata; }
        field(2; "Document No."; Code[20]) { DataClassification = SystemMetadata; }
    }

    keys { key(Key1; "Vendor No.") { Clustered = true; } }

    procedure VoidCheck(): Text
    var
        GenJnlLine: Record "Gen. Journal Line";
        CheckManagement: Codeunit CheckManagement;
    begin
        GenJnlLine.SetRange("Document Type", GenJnlLine."Document Type"::Payment);
        GenJnlLine.SetRange("Applies-to Doc. No.", "Document No.");
        GenJnlLine.SetRange("Applies-to Doc. Type", GenJnlLine."Applies-to Doc. Type"::Invoice);
        GenJnlLine.SetRange("Account Type", GenJnlLine."Account Type"::Vendor);
        GenJnlLine.SetRange("Account No.", "Vendor No.");
        if GenJnlLine.FindFirst then begin
            GenJnlLine.TestField("Bank Payment Type", GenJnlLine."Bank Payment Type"::"Computer Check");
            GenJnlLine.TestField("Check Printed", true);
            CheckManagement.VoidCheck(GenJnlLine);
            exit('General Journal Line voided for Document No. ' + GenJnlLine."Applies-to Doc. No.");
        end;
        exit('No check found to void')
    end;
}