{**************************************************************************************************}
{  WARNING:  JEDI preprocessor generated unit. Manual modifications will be lost on next release.  }
{**************************************************************************************************}

{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvDsgnEditors.PAS, released on 2002-05-26.

The Initial Developer of the Original Code is Peter Th�rnqvist [peter3@peter3.com]
Portions created by Peter Th�rnqvist are Copyright (C) 2002 Peter Th�rnqvist.
All Rights Reserved.

Contributor(s):

Last Modified: 2002-09-03
Added editors for JvFooter and JvGroupHeader

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}

{$I jvcl.inc}

unit JvQDsgnEditors;

{ Various property editors }

interface
uses
  
  
  QForms, QControls, QGraphics, QExtCtrls, Tabs, QDialogs,
  QExtDlgs, QMenus, QStdCtrls, QImgList, QWindows, Types,
  
  DsnConst,
  
  RTLConsts, DesignIntf, DesignEditors, DesignMenus,
  
  
  Classes, SysUtils;

type
  TJvHintProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

  TJvFilenameProperty = class(TStringProperty)
  protected
    procedure OnDialogShow(Sender: TObject); virtual;
    function GetFilter: string; virtual;
    function GetOptions: TOpenOptions; virtual;
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
  end;

  TJvExeNameProperty = class(TJvFilenameProperty)
  protected
    function GetFilter: string; override;
  end;

  TJvDirectoryProperty = class(TStringProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
  end;

  TJvStringsProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

  TJvStringsEditor = class(TDefaultEditor)
  protected
    
    procedure EditProperty(const Prop: IProperty; var Continue: Boolean); override;
    
    function GetStringsName: string; virtual;
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  TJvDateTimeExProperty = class(TDateTimeProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

  TJvDateExProperty = class(TDateProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

  TJvTimeExProperty = class(TTimeProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

  TJvShortCutProperty = class(TIntegerProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
  end;

  TJvDefaultImageIndexProperty = class(TIntegerProperty)
  protected
    function ImageList: TCustomImageList; virtual;
  public
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
    (*
    procedure ListMeasureWidth(const Value: string; ACanvas: TCanvas;
      var AWidth: Integer); override;
    procedure ListMeasureHeight(const Value: string; ACanvas: TCanvas;
      var AHeight: Integer); override;
    procedure ListDrawValue(const Value: string; ACanvas: TCanvas;
      const ARect: TRect; ASelected: Boolean); override;

    procedure PropDrawValue(ACanvas: TCanvas; const ARect: TRect;
      ASelected: Boolean); override;
      (*)
  end;

  

  TJvNosortEnumProperty = class(TEnumProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
  end;

  TJvIntegerProperty = class(TIntegerProperty)
  public
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
  end;

  TJvFloatProperty = class(TFloatProperty)
  public
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
  end;
                  
type
  TJvImageListEditor = class(TComponentEditor)
  private
    procedure SaveAsBitmap(ImageList: TImageList);
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;


  TJvWeekDayProperty = class(TEnumProperty)
    function GetAttributes: TPropertyAttributes; override;
  end;

  TJvComponentFormProperty = class(TComponentProperty)
  public
    procedure GetValues(Proc: TGetStrProc); override;
    procedure SetValue(const Value: string); override;
  end;


implementation

uses
  TypInfo, Math,
  
  
  QFileCtrls, QConsts,
  
  JvQTypes, JvQStringsForm, JvQDateTimeForm, JvQDsgnConsts;

function ValueName(E: Extended): string;
begin
  if E = High(Integer) then
    Result := RsMaxInt
  else
  if E = Low(Integer) then
    Result := RsMinInt
  else
  if E = High(Longint) then
    Result := RsMaxLong
  else
  if E = Low(Longint) then
    Result := RsMinLong
  else
  if E = High(ShortInt) then
    Result := RsMaxShort
  else
  if E = Low(ShortInt) then
    Result :=RsMinShort
  else
  if E = High(Word) then
    Result := RsMaxWord
  else
    Result := '';
end;

function StrToValue(const S: string): Longint;
begin
  if CompareText(S, RsMaxLong) = 0 then
    Result := High(Longint)
  else
  if CompareText(S, RsMinLong) = 0 then
    Result := Low(Longint)
  else
  if CompareText(S, RsMaxInt) = 0 then
    Result := High(Integer)
  else
  if CompareText(S, RsMinInt) = 0 then
    Result := Low(Integer)
  else
  if CompareText(S, RsMaxShort) = 0 then
    Result := High(Shortint)
  else
  if CompareText(S, RsMinShort) = 0 then
    Result := Low(Shortint)
  else
  if CompareText(S, RsMaxWord) = 0 then
    Result := High(Word)
  else
    Result := 0;
end;
  
//=== TJvFilenameProperty ====================================================

procedure TJvFilenameProperty.Edit;
begin
  with TOpenDialog.Create(nil) do
  try
    FileName := GetStrValue;
    Filter := GetFilter;
    Options := GetOptions;
    OnShow := OnDialogShow;
    if Execute then
      SetStrValue(FileName);
  finally
    Free;
  end;
end;

function TJvFilenameProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paRevertable];
end;

function TJvFilenameProperty.GetFilter: string;
begin
  Result := RsAllFilesFilter;
end;

function TJvFilenameProperty.GetOptions: TOpenOptions;
begin
  Result := [ofHideReadOnly, ofEnableSizing];
end;

function TJvFilenameProperty.GetValue: string;
begin
  Result := inherited GetValue;
  if Result = '' then
    Result := RsFileName;
end;

//=== TJvDirectoryProperty ===================================================

procedure TJvDirectoryProperty.Edit;
var
  AName: string;
  
  
  FolderName: WideString;
  
  C: TPersistent;
begin
  C := GetComponent(0);
  if C is TComponent then
    AName := TComponent(C).Name
  else
  if C is TCollectionItem then
    AName := TCollectionItem(C).GetNamePath
  else
    AName := C.ClassName;
  if SelectDirectory(AName + '.' + GetName, '', FolderName) then
    SetValue(FolderName);
end;

function TJvDirectoryProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paRevertable];
end;

function TJvDirectoryProperty.GetValue: string;
begin
  Result := inherited GetValue;
  if Result = '' then
    Result := RsDirectory;
end;

//=== TJvHintProperty ========================================================

function TJvHintProperty.GetAttributes: TPropertyAttributes;
begin
  Result := {inherited GetAttributes +} [paDialog];
end;

procedure TJvHintProperty.Edit;
var
  Temp: string;
  Comp: TPersistent;
//  I, Cnt: Integer;
begin
  with TJvStrEditDlg.Create(Application) do
  try
    Comp := GetComponent(0);
    if Comp is TComponent then
      Caption := TComponent(Comp).Name + '.' + GetName
    else
      Caption := GetName;
    Temp := GetStrValue;
    Memo.Lines.Text := Temp;
    UpdateStatus(nil);
    if ShowModal = mrOk then
    begin
      Temp := Memo.Text;
      while (Length(Temp) > 0) and (Temp[Length(Temp)] < ' ') do
        System.Delete(Temp, Length(Temp), 1);
      SetStrValue(Temp);
    end;
  finally
    Free;
  end;
end;

//=== TJvStringsProperty =====================================================

procedure TJvStringsProperty.Edit;
var
  Temp: string;
  Comp: TPersistent;
//  I, Cnt: Integer;
begin
  with TJvStrEditDlg.Create(Application) do
  try
    Comp := GetComponent(0);
    if Comp is TComponent then
      Caption := TComponent(Comp).Name + '.' + GetName
    else
      Caption := GetName;
    Temp := GetStrValue;
    Memo.Lines.Text := Temp;
    UpdateStatus(nil);
    if ShowModal = mrOk then
    begin
      Temp := Memo.Text;
      while (Length(Temp) > 0) and (Temp[Length(Temp)] < ' ') do
        System.Delete(Temp, Length(Temp), 1);
      SetStrValue(Temp);
    end;
  finally
    Free;
  end;
end;

function TJvStringsProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paRevertable];
end;


//=== TJvStringsProperty =====================================================


procedure TJvStringsEditor.EditProperty(const Prop: IProperty; var Continue: Boolean);
var
  PropName: string;
begin
  PropName := Prop.GetName;
  if SameText(PropName, GetStringsName) then
  begin
    Prop.Edit;
    Continue := False;
  end;
end;


procedure TJvStringsEditor.ExecuteVerb(Index: Integer);
begin
  if Index = 0 then
    Edit
  else
    inherited ExecuteVerb(Index);
end;

function TJvStringsEditor.GetStringsName: string;
begin
  Result := RsItems;
end;

function TJvStringsEditor.GetVerb(Index: Integer): string;
begin
  if Index = 0 then
    Result := Format(RsFmtEditEllipsis, [GetStringsName])
  else
    Result := '';
end;

function TJvStringsEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

//=== TJvDateTimeExProperty ==================================================

procedure TJvDateTimeExProperty.Edit;
var
  D: TDateTime;
begin
  D := GetFloatValue;
  if D = 0.0 then
    D := Now;
  if TFrmSelectDateTimeDlg.SelectDateTime(D, dstDateTime) then
  begin
    SetFloatValue(D);
    Designer.Modified;
  end;
end;

function TJvDateTimeExProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paDialog];
end;

//=== TJvDateExProperty ======================================================

procedure TJvDateExProperty.Edit;
var
  D: TDateTime;
begin
  D := GetFloatValue;
  if D = 0.0 then
    D := Now;
  if TFrmSelectDateTimeDlg.SelectDateTime(D, dstDate) then
  begin
    SetFloatValue(D);
    Designer.Modified;
  end;
end;

function TJvDateExProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paDialog];
end;

//=== TJvTimeExProperty ======================================================

procedure TJvTimeExProperty.Edit;
var
  D: TDateTime;
begin
  D := GetFloatValue;
  if D = 0.0 then
    D := Now
  else // (p3) we need the date part or we might get a "Must be in ShowCheckBox mode" error
    D := SysUtils.Date + Frac(D);
  if TFrmSelectDateTimeDlg.SelectDateTime(D, dstTime) then
  begin
    SetFloatValue(Frac(D)); // (p3) only return the time portion
    Designer.Modified;
  end;
end;

function TJvTimeExProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paDialog];
end;

function TJvDefaultImageIndexProperty.ImageList: TCustomImageList;
const
  cImageList = 'ImageList';
  cImages = 'Images';
begin
  if TypInfo.GetPropInfo(GetComponent(0), cImageList) <> nil then
    Result := TCustomImageList(TypInfo.GetObjectProp(GetComponent(0), cImageList))
  else
  if TypInfo.GetPropInfo(GetComponent(0), cImages) <> nil then
    Result := TCustomImageList(TypInfo.GetObjectProp(GetComponent(0), cImages))
  else
    Result := nil;
end;

function TJvDefaultImageIndexProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paSortList, paMultiselect];
end;

function TJvDefaultImageIndexProperty.GetValue: string;
begin
  Result := IntToStr(GetOrdValue);
end;

procedure TJvDefaultImageIndexProperty.SetValue(const Value: string);
var
  XValue: Integer;
begin
  try
    XValue := StrToInt(Value);
    SetOrdValue(XValue);
  except
    inherited SetValue(Value);
  end;
end;

procedure TJvDefaultImageIndexProperty.GetValues(Proc: TGetStrProc);
var
  Tmp: TCustomImageList;
  I: Integer;
begin
  Tmp := ImageList;
  if Assigned(Tmp) then
    for I := 0 to Tmp.Count - 1 do
      Proc(IntToStr(I));
end;

(*)

procedure TJvDefaultImageIndexProperty.ListDrawValue(const Value: string;
  ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean);
var
  Tmp: TCustomImageList;
  R: TRect;
begin
  inherited ListDrawValue(Value, ACanvas, ARect, ASelected);
  Tmp := ImageList;
  if Tmp <> nil then
  begin
    R := ARect;
    ACanvas.FillRect(ARect);
    Tmp.Draw(ACanvas, ARect.Left, ARect.Top, StrToInt(Value));
    OffsetRect(R, Tmp.Width + 2, 0);
    DrawText(ACanvas.Handle, PChar(Value), -1, R, 0);
  end;
end;

procedure TJvDefaultImageIndexProperty.ListMeasureHeight(const Value: string;
  ACanvas: TCanvas; var AHeight: Integer);
var
  Tmp: TCustomImageList;
begin
  Tmp := ImageList;
  if Assigned(Tmp) then
    AHeight := Max(Tmp.Height + 2, ACanvas.TextHeight(Value) + 2);
end;

procedure TJvDefaultImageIndexProperty.ListMeasureWidth(const Value: string;
  ACanvas: TCanvas; var AWidth: Integer);
var
  Tmp: TCustomImageList;
begin
  Tmp := ImageList;
  if Assigned(Tmp) then
    AWidth := Tmp.Width + ACanvas.TextHeight(Value) + 4;
end;
procedure TJvDefaultImageIndexProperty.PropDrawValue(ACanvas: TCanvas;
  const ARect: TRect; ASelected: Boolean);
begin
//  if GetVisualValue <> '' then
//    ListDrawValue(GetVisualValue, ACanvas, ARect, True)
//  else
  inherited PropDrawValue(ACanvas, ARect, ASelected);
end;
(*)



//=== TJvShortCutProperty ======================================================

function TJvShortCutProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paMultiSelect, paRevertable];
end;

function TJvShortCutProperty.GetValue: string;
begin
  try
    Result := ShortCutToText(GetOrdValue);
    if Result = '' then
      Result := RsNone;
  except
    Result := inherited GetValue;
  end;
end;

procedure TJvShortCutProperty.GetValues(Proc: TGetStrProc);
var
  Key: Word;
  Shift: TShiftState;
begin
  Proc(RsNone);

  Shift := [ssCtrl];
  for Key := Ord('A') to Ord('Z') do
    Proc(ShortCutToText(ShortCut(Key, Shift)));

  Shift := [ssAlt, ssCtrl];
  for Key := Ord('A') to Ord('Z') do
    Proc(ShortCutToText(ShortCut(Key, Shift)));

  Shift := [];
  for Key := VK_F1 to VK_F10 do
    Proc(ShortCutToText(ShortCut(Key, Shift)));

  Shift := [ssCtrl];
  for Key := VK_F1 to VK_F10 do
    Proc(ShortCutToText(ShortCut(Key, Shift)));

  Shift := [ssShift];
  for Key := VK_F1 to VK_F10 do
    Proc(ShortCutToText(ShortCut(Key, Shift)));

  Shift := [ssShift, ssCtrl];
  for Key := VK_F1 to VK_F10 do
    Proc(ShortCutToText(ShortCut(Key, Shift)));

  Shift := [ssShift, ssAlt, ssCtrl];
  for Key := VK_F1 to VK_F10 do
    Proc(ShortCutToText(ShortCut(Key, Shift)));

  Proc(ShortCutToText(ShortCut(VK_INSERT, [])));
  Proc(ShortCutToText(ShortCut(VK_INSERT, [ssShift])));
  Proc(ShortCutToText(ShortCut(VK_INSERT, [ssCtrl])));

  Proc(ShortCutToText(ShortCut(VK_DELETE, [])));
  Proc(ShortCutToText(ShortCut(VK_DELETE, [ssShift])));
  Proc(ShortCutToText(ShortCut(VK_DELETE, [ssCtrl])));

  Proc(ShortCutToText(ShortCut(VK_BACK, [ssAlt])));
  Proc(ShortCutToText(ShortCut(VK_BACK, [ssAlt, ssShift])));
end;

procedure TJvShortCutProperty.SetValue(const Value: string);
begin
  try
    SetOrdValue(TextToShortCut(Value));
  except
    inherited SetValue(Value);
  end;
end;

//=== TJvNosortEnumProperty ==================================================

function TJvNosortEnumProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes - [paSortList];
end;

procedure TJvFilenameProperty.OnDialogShow(Sender: TObject);
begin
  // (rom) Where does chx1 come from?
  
end;

//=== TJvExeNameProperty =====================================================

function TJvExeNameProperty.GetFilter: string;
begin
  Result := RsExecutableFilesExeExeAllFiles;
end;

//=== TJvIntegerProperty =====================================================

function TJvIntegerProperty.GetValue: string;
begin
  Result := ValueName(GetOrdValue);
  if Result = '' then
    Result := IntToStr(GetOrdValue);
end;

procedure TJvIntegerProperty.SetValue(const Value: string);
var
  L: Longint;
begin
  L := StrToValue(Value);
  if L = 0 then
    L := StrToInt(Value);
  inherited SetValue(IntToStr(L));
end;

//=== TJvFloatProperty =======================================================

function TJvFloatProperty.GetValue: string;
const
  Precisions: array [TFloatType] of Integer = (7, 15, 18, 18, 18);
begin
  Result := ValueName(GetFloatValue);
  if Result = '' then
    Result := FloatToStrF(GetFloatValue, ffGeneral,
      Precisions[GetTypeData(GetPropType)^.FloatType], 0);
end;

procedure TJvFloatProperty.SetValue(const Value: string);
var
  L: Longint;
begin
  L := StrToValue(Value);
  if L <> 0 then
    SetFloatValue(L)
  else
    SetFloatValue(StrToFloat(Value));
end;

procedure TJvImageListEditor.SaveAsBitmap(ImageList: TImageList);
var
  Bitmap: TBitmap;
  SaveDlg: TOpenDialog;
  I: Integer;
begin
  if ImageList.Count > 0 then
  begin
    SaveDlg := TSavePictureDialog.Create(Application);
    with SaveDlg do
    try
      Options := [ofHideReadOnly, ofOverwritePrompt];
      DefaultExt := GraphicExtension(TBitmap);
      Filter := GraphicFilter(TBitmap);
      if Execute then
      begin
        Bitmap := TBitmap.Create;
        try
          with Bitmap do
          begin
            Width := ImageList.Width * ImageList.Count;
            Height := ImageList.Height;
            if ImageList.BkColor <> clNone then
              Canvas.Brush.Color := ImageList.BkColor
            else
              Canvas.Brush.Color := clWindow;
            Canvas.FillRect(Bounds(0, 0, Width, Height));
            for I := 0 to ImageList.Count - 1 do
              ImageList.Draw(Canvas, ImageList.Width * I, 0, I);
            HandleType := bmDIB;
            if PixelFormat in [pf15bit, pf16bit] then
            try
              PixelFormat := pf24bit;
            except
            end;
          end;
          Bitmap.SaveToFile(FileName);
        finally
          Bitmap.Free;
        end;
      end;
    finally
      Free;
    end;
  end
  else
    Beep;
end;

procedure TJvImageListEditor.ExecuteVerb(Index: Integer);
begin
  if Designer <> nil then
    case Index of
      0:
        if EditImageList(Component as TImageList) then
          Designer.Modified;
      1:
        SaveAsBitmap(TImageList(Component));
    end;
end;

function TJvImageListEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0:
      Result := SImageListEditor;
    1:
      Result := RsSaveImageList;
  else
    Result := '';
  end;
end;

function TJvImageListEditor.GetVerbCount: Integer;
begin
  Result := 2;
end;



//=== TJvWeekDayProperty =====================================================

function TJvWeekDayProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect, paValueList];
end;

//=== TJvComponentFormProperty ===============================================

procedure TJvComponentFormProperty.GetValues(Proc: TGetStrProc);
var
  Form: TComponent;
begin
  inherited GetValues(Proc);
  Form := Designer. Root ;
  if (Form is GetTypeData(GetPropType)^.ClassType) and (Form.Name <> '') then
    Proc(Form.Name);
end;

procedure TJvComponentFormProperty.SetValue(const Value: string);
var
  Component: TComponent;
  Form: TComponent;
begin
  Component := Designer.GetComponent(Value);
  Form := Designer. Root ;
  if ((Component = nil) or not (Component is GetTypeData(GetPropType)^.ClassType)) and
    (CompareText(Form.Name, Value) = 0) then
  begin
    if not (Form is GetTypeData(GetPropType)^.ClassType) then
      raise EPropertyError.Create(SInvalidPropertyValue);
    SetOrdValue(Longint(Form));
  end
  else
    inherited SetValue(Value);
end;

end.

