tableextension 80507 "PTEAP Sales Cr.Memo Line" extends "Sales Cr.Memo Line"
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
    }
}