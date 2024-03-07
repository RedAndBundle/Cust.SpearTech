tableextension 80607 "PTEPI Sales Cr.Memo Line" extends "Sales Cr.Memo Line"
{
    fields
    {
        field(80602; "PTEPI Policy Number"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Cr.Memo Header"."PTEPI Policy Number" where("No." = field("Document No.")));
            Caption = 'Policy Number';
        }
        field(80603; "PTEPI Spear No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Spear Id';
        }
    }
}