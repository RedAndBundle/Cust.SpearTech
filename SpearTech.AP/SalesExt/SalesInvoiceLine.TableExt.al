tableextension 80505 "PTEAP Sales Invoice Line" extends "Sales Invoice Line"
{
    fields
    {
        field(80500; "PTEAP Task/Activity"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Task/Activity';
        }
        field(80501; "PTEAP Task Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Task Date';
        }
        field(80502; "PTEAP Claim Number"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Invoice Header"."PTEAP Claim Number" where("No." = field("Document No.")));
            Caption = 'Claim Number';
        }
        field(80503; "PTEAP Spear Id"; Guid)
        {
            DataClassification = CustomerContent;
            Caption = 'Spear Id';
        }
    }
}