tableextension 50101 "PTE Check Arguments" extends "ForNAV Check Arguments"
{
    fields
    {
        field(50100; "PTE Document No."; Code[20]) { DataClassification = ToBeClassified; }
        field(50101; "PTE Output Type"; Option)
        {
            OptionMembers = "Print","PDF";
            OptionCaption = 'Print,PDF';
            DataClassification = ToBeClassified;
        }
    }

}