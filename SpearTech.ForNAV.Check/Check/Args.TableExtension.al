tableextension 80401 "PTE Check Arguments" extends "ForNAV Check Arguments"
{
    fields
    {
        field(80400; "PTE Document No."; Code[20]) { DataClassification = ToBeClassified; }
        field(80401; "PTE Output Type"; Option)
        {
            OptionMembers = "Print","PDF","Zip";
            OptionCaption = 'Print,PDF,Zip';
            DataClassification = ToBeClassified;
        }
    }

}