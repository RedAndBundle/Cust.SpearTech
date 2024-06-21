tableextension 80605 "PTEPI Sales Invoice Line" extends "Sales Invoice Line"
{
    fields
    {
        field(80602; "PTEPI Policy Number"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Invoice Header"."PTEPI Policy Number" where("No." = field("Document No.")));
            Caption = 'Policy Number';
        }
        field(80603; "PTEPI Spear No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Spear No.';
        }
        field(80604; "PTEPI Spear Id"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Spear Id';
        }
    }
}