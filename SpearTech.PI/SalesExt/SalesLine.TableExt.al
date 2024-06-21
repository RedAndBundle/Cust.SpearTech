tableextension 80601 "PTEPI Sales Line" extends "Sales Line"
{
    fields
    {
        field(80602; "PTEPI Policy Number"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."PTEPI Policy Number" where("Document Type" = field("Document Type"), "No." = field("Document No.")));
            Caption = 'Policy Number';
        }
        field(80603; "PTEPI Spear No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Spear No.';
        }
        field(80600; "PTEPI Spear Id"; Guid)
        {
            DataClassification = CustomerContent;
            Caption = 'Spear Id';
        }
    }
}