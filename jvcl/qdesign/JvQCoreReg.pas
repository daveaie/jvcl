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

The Original Code is: JvCoreReg.PAS, released on 2002-05-26.

The Initial Developer of the Original Code is John Doe.
Portions created by John Doe are Copyright (C) 2003 John Doe.
All Rights Reserved.

Contributor(s):

Last Modified: 2003-11-09

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}

{$I jvcl.inc}

unit JvQCoreReg;

interface

procedure Register;

implementation
uses
  Classes,


  QControls, QStdCtrls, QExtCtrls, QGraphics, QActnList, QImgList, QDialogs,
  Types,  QTypes, QExtDlgs,
  JvQExStdCtrls, JvQExExtCtrls, JvQExControls, JvQExCheckLst, JvQExComCtrls,
  JvQExButtons, JvQExGrids, JvQExMask,

  DesignEditors, DesignIntf,

  JvQTypes, JvQDsgnConsts, JvQJCLUtils, JVQCLVer, JvQComponent,
  JvQActions, JvQActnResForm, JvQJVCLAboutForm,
  JvQDsgnEditors,
  JvQIDEZoom,
  JvQJVCLAboutEditor,

  JvQPaintBoxEditor,
  {$IFDEF MSWINDOWS}
  JvQBaseDlgEditor, JvQBaseDlg,
  JvQAppRegistryStorage,  JvQContextProvider,
  JvQColorProvider,JvQColorProviderEditors, JvQDataProviderEditors,
  {$ENDIF MSWINDOWS}
  JvQAppIniStorage,
  JvQAppStorage;

{$IFDEF MSWINDOWS}
{$R ..\resources\JvCoreReg.dcr}
{$ENDIF MSWINDOWS}
{$IFDEF LINUX}
{$R ../Resources/JvCoreReg.dcr}
{$ENDIF LINUX}
{$DEFINE JVCL_REGISTER_GLOBAL_DESIGNEDITORS}

procedure Register;
const
  BaseClass: TClass = TComponent;
begin
(*)
  RegisterComponents('Extended Standard', [TJvExLabel, TJvExPanel, TJvExBevel,
    TJvExControlBar, TJvExPubRadioGroup, TJvExEdit, TJvExButton, TJvExCheckBox,
    TJvExComboBox, TJvExGroupBox, TJvExListBox, TJvExMemo, TJvExRadioButton,
    TJvExScrollBar]);
  RegisterComponents('Extended Additional', [TJvExBitBtn, TJvExSpeedButton,
    TJvExCheckListBox, TJvExImage, TJvExPaintBox, TJvExShape, TJvExSplitter,
    TJvExStringGrid, TJvExDrawGrid, TJvExMaskEdit]);
  RegisterComponents('Extended Common', [TJvExTabControl, TJvExPageControl,
    TJvExPubProgressBar, TJvExPubTreeView, TJvExPubListView, TJvExHeaderControl,
    TJvExAnimate, TJvExStatusBar, TJvExToolBar]);
(*)
  RegisterComponents(RsPaletteNonVisual, [TJvJVCLAboutComponent
   {$IFDEF MSWINDOWS},
 TJvContextProvider, TJvColorProvider, TJvColorMappingProvider
   {$ENDIF}]);
  RegisterComponents(RsPalettePersistence, [TJvAppStorage,
    {$IFDEF MSWINDOWS}
    TJvAppRegistryStorage,
    {$ENDIF MSWINDOWS}
    TJvAppIniFileStorage]);
  RegisterComponents(RsPaletteDialog, [TOpenPictureDialog, TSavePictureDialog, TPrinterSetupDialog]);

  RegisterPropertyEditor(TypeInfo(TJVCLAboutInfo), nil, 'AboutJVCLX', TJVCLAboutDialogProperty);
  {$IFDEF JVCL_REGISTER_GLOBAL_DESIGNEDITORS}

  RegisterPropertyEditor(TypeInfo(string), BaseClass, 'FolderName', TJvDirectoryProperty);
  RegisterPropertyEditor(TypeInfo(string), BaseClass, 'DirectoryName', TJvDirectoryProperty);
  RegisterPropertyEditor(TypeInfo(string), BaseClass, 'InitialDir', TJvDirectoryProperty);
  RegisterPropertyEditor(TypeInfo(widestring), BaseClass, '', TJvHintProperty);
//  RegisterPropertyEditor(TypeInfo(string), BaseClass, 'Hint', TJvHintProperty);
  RegisterPropertyEditor(TypeInfo(TCaption), BaseClass, '', TJvHintProperty);
  RegisterPropertyEditor(TypeInfo(string), BaseClass, 'Text', TJvHintProperty);

  RegisterPropertyEditor(TypeInfo(Integer), BaseClass, '', TJvIntegerProperty);
  RegisterPropertyEditor(TypeInfo(Shortint), BaseClass, '', TJvIntegerProperty);
  RegisterPropertyEditor(TypeInfo(Smallint), BaseClass, '', TJvIntegerProperty);
  RegisterPropertyEditor(TypeInfo(Longint), BaseClass, '', TJvIntegerProperty);
  RegisterPropertyEditor(TypeInfo(Word), BaseClass, '', TJvIntegerProperty);
  RegisterPropertyEditor(TypeInfo(Byte), BaseClass, '', TJvIntegerProperty);
  RegisterPropertyEditor(TypeInfo(Cardinal), BaseClass, '', TJvIntegerProperty);

  RegisterPropertyEditor(TypeInfo(Single), BaseClass, '', TJvFloatProperty);
  RegisterPropertyEditor(TypeInfo(Double), BaseClass, '', TJvFloatProperty);
  RegisterPropertyEditor(TypeInfo(Extended), BaseClass, '', TJvFloatProperty);
  RegisterPropertyEditor(TypeInfo(Currency), BaseClass, '', TJvFloatProperty);

  RegisterComponentEditor(TPaintBox, TJvPaintBoxEditor);
//  RegisterComponentEditor(TCustomImageList, TJvImageListEditor);
//  RegisterComponentEditor(TImageList, TJvImageListEditor);
  RegisterComponentEditor(TCommonDialog, TJvBaseDlgEditor);
  RegisterActions(RsJVCLActionsCategory,
    [{$IFDEF MSWINDOWS}TJvSendMailAction,{$ENDIF} TJvWebAction], TJvStandardActions);
  {$ENDIF JVCL_REGISTER_GLOBAL_DESIGNEDITORS}

  RegisterPropertyEditor(TypeInfo(TShortCut), TJvComponent, '', TJvShortCutProperty);
  RegisterPropertyEditor(TypeInfo(TDayOfWeekName), nil, '', TJvWeekDayProperty);


  RegisterZoom;


  end;

end.
