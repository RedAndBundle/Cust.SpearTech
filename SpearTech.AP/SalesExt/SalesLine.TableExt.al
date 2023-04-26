tableextension 80501 "PTEAP Sales Line" extends "Sales Line"
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

    trigger OnBeforeDelete()
    begin
        PTEBlockIfHasAPEntry();
    end;

    trigger OnBeforeModify()
    begin
        PTEBlockIfHasAPEntry();
    end;

    trigger OnBeforeRename()
    begin
        PTEBlockIfHasAPEntry();
    end;

    local procedure PTEBlockIfHasAPEntry()
    var
        CannotModifyErr: Label 'You cannot modify this line because it was created from the AP Entry API.';
    begin
        if "PTEAP Task/Activity" <> '' then
            Error(CannotModifyErr);
    end;
}