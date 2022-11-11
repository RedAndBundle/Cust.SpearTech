tableextension 80400 "PTE Bank Account" extends "Bank Account"
{
    fields
    {
        field(80400; "PTE Check Name"; Text[100])
        {
            Caption = 'Check Name';
            DataClassification = CustomerContent;
        }
        field(80401; "PTE Check Name 2"; Text[50])
        {
            Caption = 'Check Name 2';
            DataClassification = CustomerContent;
        }
        field(80402; "PTE Check Address"; Text[100])
        {
            Caption = 'Check Address';
            DataClassification = CustomerContent;
        }
        field(80403; "PTE Check Address 2"; Text[50])
        {
            Caption = 'Check Address 2';
            DataClassification = CustomerContent;
        }
        field(80404; "PTE Check City"; Text[30])
        {
            Caption = 'Check City';
            DataClassification = CustomerContent;
            TableRelation = if ("Country/Region Code" = CONST('')) "Post Code".City
            else
            if ("Country/Region Code" = filter(<> '')) "Post Code".City where("Country/Region Code" = field("Country/Region Code"));
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                PostCode: Record "Post Code";
            begin
                PostCode.LookupPostCode(City, "Post Code", County, "Country/Region Code");
            end;

            trigger OnValidate()
            var
                PostCode: Record "Post Code";
            begin
                PostCode.ValidateCity(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(80405; "PTE Check Country/Region Code"; Code[10])
        {
            Caption = 'Check Country/Region Code';
            TableRelation = "Country/Region";
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                PostCode: Record "Post Code";
            begin
                PostCode.CheckClearPostCodeCityCounty(City, "Post Code", County, "Country/Region Code", xRec."Country/Region Code");
            end;
        }
        field(80406; "PTE Check Post Code"; Code[20])
        {
            Caption = 'Check Post Code';
            DataClassification = CustomerContent;
            TableRelation = if ("Country/Region Code" = const('')) "Post Code"
            else
            if ("Country/Region Code" = FILTER(<> '')) "Post Code" where("Country/Region Code" = field("Country/Region Code"));
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                PostCode: Record "Post Code";
            begin
                PostCode.LookupPostCode(City, "Post Code", County, "Country/Region Code");
            end;

            trigger OnValidate()
            var
                PostCode: Record "Post Code";
            begin
                PostCode.ValidatePostCode(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(80407; "PTE Void Text"; Text[100])
        {
            Caption = 'Void text';
            DataClassification = CustomerContent;
        }
        field(80410; "PTE 1st Signature Text"; Text[100])
        {
            Caption = '1st Signature Text';
            DataClassification = CustomerContent;
        }
        field(80411; "PTE 1st Signature"; Blob)
        {
            Caption = '1st Signature';
            DataClassification = CustomerContent;
        }
        field(80412; "PTE 1st Signature Filename"; Text[100])
        {
            Caption = '1st Signature Filename';
            DataClassification = CustomerContent;
            Editable = false;
            InitValue = 'Click to import...';
        }
        field(80413; "PTE 1st Signature Logic"; Decimal)
        {
            Caption = '1st Signature Logic';
            DataClassification = CustomerContent;
        }
        field(80420; "PTE 2nd Signature Text"; Text[100])
        {
            Caption = '2nd Signature Text';
            DataClassification = CustomerContent;
        }
        field(80421; "PTE 2nd Signature"; Blob)
        {
            Caption = '2nd Signature';
            DataClassification = CustomerContent;
        }
        field(80422; "PTE 2nd Signature Filename"; Text[100])
        {
            Caption = '2nd Signature Filename';
            DataClassification = CustomerContent;
            Editable = false;
            InitValue = 'Click to import...';
        }
        field(80423; "PTE 2nd Signature Logic"; Decimal)
        {
            Caption = '2nd Signature Logic';
            DataClassification = CustomerContent;
        }
        field(80430; "PTE MICR Offset X"; Integer)
        {
            Caption = 'MICR Offset X';
            DataClassification = CustomerContent;
        }
        field(80431; "PTE MICR Offset Y"; Integer)
        {
            Caption = 'MICR Offset X';
            DataClassification = CustomerContent;
        }
    }

    procedure DrillDownBlob(BlobFieldNo: Integer)
    var
        BlobDrilldown: Codeunit "ForNAV Blob Drilldown";
    begin
        if not BlobHasValue(BlobFieldNo) then begin
            ImportWatermarkFromClientFile(BlobFieldNo);
            Modify();
            exit;
        end;

        case BlobDrilldown.DrilldownSelect() of
            1:
                DownloadWatermark(BlobFieldNo);
            2:
                begin
                    ImportWatermarkFromClientFile(BlobFieldNo);
                    Modify();
                end;
            3:
                begin
                    DeleteBlob(BlobFieldNo);
                    Modify();
                end;
        end;
    end;

    procedure ImportWatermarkFromClientFile(Which: Integer): Boolean
    var
        TempBlob: Record "ForNAV Core Setup" temporary;
        FileName: Text;
        is: InStream;
        os: OutStream;
        SelectFile: Label 'Select a file';
    begin
        if not UploadIntoStream(SelectFile, '', 'PDF files (*.pdf)|*.pdf|All files (*.*)|*.*', FileName, is) then
            exit;

        TempBlob.Blob.CreateOutstream(os);
        CopyStream(os, is);

        case Which of
            FieldNo("PTE 1st Signature"):
                begin
                    "PTE 1st Signature" := TempBlob.Blob;
                    "PTE 1st Signature Filename" := GetFileNameFromFile(FileName);
                end;
            FieldNo("PTE 2nd Signature"):
                begin
                    "PTE 2nd Signature" := TempBlob.Blob;
                    "PTE 2nd Signature Filename" := GetFileNameFromFile(FileName);
                end;
            else
                exit(false);
        end;
        exit(true);
    end;

    local procedure DownloadWatermark(Which: Integer)
    var
        FileName: Text;
        is: InStream;
    begin
        case Which of
            FieldNo("PTE 1st Signature"):
                begin
                    CalcFields("PTE 1st Signature");
                    "PTE 1st Signature".CreateInStream(is);
                    FileName := "PTE 1st Signature Filename";
                end;
            FieldNo("PTE 2nd Signature"):
                begin
                    CalcFields("PTE 2nd Signature");
                    "PTE 2nd Signature".CreateInStream(is);
                    FileName := "PTE 2nd Signature Filename";
                end;
            else
                exit;
        end;
        DownloadFromStream(is, '', '', '', FileName);
    end;

    local procedure DeleteBlob(Which: Integer)
    var
        FileName: Text;
        is: InStream;
    begin
        FileName := 'Click to import...';
        case Which of
            FieldNo("PTE 1st Signature"):
                begin
                    "PTE 1st Signature Filename" := FileName;
                    Clear("PTE 1st Signature");
                end;
            FieldNo("PTE 2nd Signature"):
                begin
                    "PTE 2nd Signature Filename" := FileName;
                    Clear("PTE 2nd Signature");
                end;
        end;
    end;

    procedure BlobHasValue(Which: Integer): Boolean
    begin
        case Which of
            FieldNo("PTE 1st Signature"):
                begin
                    CalcFields("PTE 1st Signature");
                    exit("PTE 1st Signature".HasValue);
                end;
            FieldNo("PTE 2nd Signature"):
                begin
                    CalcFields("PTE 2nd Signature");
                    exit("PTE 2nd Signature".HasValue);
                end;
            else
                exit(false);
        end;
    end;

    local procedure GetFileNameFromFile(Value: Text): Text
    var
        LastPos: Integer;
        i: Integer;
    begin
        while i < StrLen(Value) do begin
            i := i + 1;
            if Value[i] = '\' then
                LastPos := i;
        end;

        exit(CopyStr(Value, LastPos + 1));
    end;
}