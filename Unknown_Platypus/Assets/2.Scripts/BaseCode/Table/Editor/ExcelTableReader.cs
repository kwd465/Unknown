using UnityEngine;
using UnityEditor;
using System.IO;
using NPOI.SS.UserModel;
using NPOI.HSSF.UserModel;
using NPOI.XSSF.UserModel;
using System.Collections.Generic;
using UnityEngine.Events;

public class ExcelFileSheet
{
    public string sheetName;    
    public UnityAction<string, List<Dictionary<string, string>>> excelLoad;

    public ExcelFileSheet(string _sheetName, UnityAction<string, List<Dictionary<string, string>>> _excelLoad)
    {      
        sheetName = _sheetName;
        excelLoad = _excelLoad;        
    }
}

public class ExcelFile
{
    public string path;
    public List<ExcelFileSheet> m_sheetList = new List<ExcelFileSheet>();   

    public ExcelFile(string _path)
    {
        path = string.Format("{0}{1}", Application.dataPath, _path);        
    }

    public ExcelFile(string _path, string _sheet, UnityAction<string, List<Dictionary<string, string>>> _excelLoad)
    {
        path = string.Format("{0}{1}", Application.dataPath, _path);
        m_sheetList.Add(new ExcelFileSheet(_sheet, _excelLoad));
    }

    public void AddSheet( ExcelFileSheet _sheet )
    {
        m_sheetList.Add(_sheet);
    }

    public void Load(string _sheetName, List<Dictionary<string, string>> _data)
    {       
        for( int i=0; i< m_sheetList.Count; ++i )
        {
            if(string.Compare(m_sheetList[i].sheetName, _sheetName, true ) == 0 )
            {               
                m_sheetList[i].excelLoad(_sheetName, _data);
            }
        }
    }
}



public class ExcelFileGroup
{
    private TableBase m_tablebase;
    private List<ExcelFile> m_excelFileList = new List<ExcelFile>();

    public TableBase getTable
    {
        get
        {
            return m_tablebase;
        }
    }


    public ExcelFileGroup( TableBase _tableBase )
    {
        m_tablebase = _tableBase;
    }

    public void AddExcelFile(ExcelFile _file)
    {
        m_excelFileList.Add(_file);
    }

    public bool LoadExcel( UnityAction<ExcelFile> _loadExcel)
    {
        for( int i=0; i< m_excelFileList.Count; ++i )
        {
            _loadExcel(m_excelFileList[i]);
        }

        m_tablebase.Write();
        AssetDatabase.Refresh();
        return true;
    }
}

public class ExcelTableReader : EditorWindow
{	
    [MenuItem("TableTool/ExcelTable")]
	static void Init () 
    {
        EditorWindow.GetWindow<ExcelTableReader>(false, "ExcelTable");
    }	
	
    string m_textSucc;
    bool m_succ = false;  

    List<ExcelFileGroup> m_excel = null;

    public void AddLoadExcelGroup( string _path, TableBase _tableBase, string _sheet )
    {
        ExcelFileGroup _table = new ExcelFileGroup(_tableBase);
        ExcelFile _excelFile = new ExcelFile(_path);
        _excelFile.AddSheet(new ExcelFileSheet(_sheet, _table.getTable.LoadExcel));
        _table.AddExcelFile(_excelFile);
        m_excel.Add(_table);
    }

    public void AddLoadExcelGroup(string _path, TableBase _tableBase, string _sheet, UnityAction<string, List<Dictionary<string, string>>> _loadExcel)
    {
        ExcelFileGroup _table = new ExcelFileGroup(_tableBase);
        ExcelFile _excelFile = new ExcelFile(_path);
        _excelFile.AddSheet(new ExcelFileSheet(_sheet, _loadExcel));
        _table.AddExcelFile(_excelFile);
        m_excel.Add(_table);
    }

    void InitExcelFileList()
    {
        ClassFileSave _fileSave = new ClassFileSave();     

        _fileSave.SetResPath(EditorUtil.GetResPath);

        m_excel = new List<ExcelFileGroup>();

        AddLoadExcelGroup("/../Table/StringTable.xlsx", new StringTable(_fileSave), "Sheet1");
        AddLoadExcelGroup("/../Table/StringBasicTable.xlsx", new StringBasicTable(_fileSave), "Sheet1");
        AddLoadExcelGroup("/../Table/CharacterTable.xlsx", new CharacterTable(_fileSave), "Sheet1");
        AddLoadExcelGroup("/../Table/MonsterTable.xlsx", new MonsterTable(_fileSave), "Sheet1");
        AddLoadExcelGroup("/../Table/SkillTable.xlsx", new SkillTable(_fileSave), "Sheet1");
        AddLoadExcelGroup("/../Table/SkillOptionTable.xlsx", new SkillOptionTable(_fileSave), "Sheet1");
        AddLoadExcelGroup("/../Table/StageTable.xlsx", new StageTable(_fileSave), "Sheet1");
        AddLoadExcelGroup("/../Table/WaveTable.xlsx", new WaveTable(_fileSave), "Sheet1");
        AddLoadExcelGroup("/../Table/EquipTable.xlsx", new EquipTable(_fileSave), "Sheet1");
        AddLoadExcelGroup("/../Table/ItemTable.xlsx", new ItemTable(_fileSave), "Sheet1");
        AddLoadExcelGroup("/../Table/GachaTable.xlsx", new GachaTable(_fileSave), "Sheet1");
    }

    void OnGUI ()
    {

        if(Application.isPlaying)
        {
            GUILayout.TextArea("플레이중엔 사용할수 없습니다.");
            return;
        }


        if (GUILayout.Button("Load : All Table", GUI.skin.button))
        {
            InitExcelFileList();
            m_succ = true;
            for (int i = 0; i < m_excel.Count; ++i)
            {
                if (false == m_excel[i].LoadExcel(LoadExcel))
                {
                    m_succ = false;
                }
            }

            if (true == m_succ)
            {
                m_textSucc = System.DateTime.Now.ToString();
            }
            else
            {
                m_textSucc = "load failed";
            }

            m_excel = null;
        }

        if(m_excel == null || m_excel.Count == 0)
            InitExcelFileList();

        for (int i = 0; i < m_excel.Count; i++)
        {
            if (GUILayout.Button("Load :" + m_excel[i].getTable.getPath, GUI.skin.button))
                SelectLoadExcel(i);
        }

        GUILayout.TextArea(m_textSucc);       
    }
    
    public void SelectLoadExcel(int index)
    {
        
        m_succ = true;

        if (false == m_excel[index].LoadExcel(LoadExcel))
        {
            m_succ = false;
        }

        if (true == m_succ)
        {
            m_textSucc = System.DateTime.Now.ToString();
        }
        else
        {
            m_textSucc = "load failed";
        }
    }

    public void LoadExcel(ExcelFile _data)
    {
        using (FileStream stream = File.Open(_data.path, FileMode.Open, FileAccess.Read, FileShare.ReadWrite))
        {
            IWorkbook book = null;
            if (Path.GetExtension(_data.path) == ".xls")
            {
                book = new HSSFWorkbook(stream);
            }
            else
            {
                book = new XSSFWorkbook(stream);
            }

            for (int i = 0; i < book.NumberOfSheets; ++i)
            {
                ISheet s = book.GetSheetAt(i);      
                _data.Load(s.SheetName, CreateExcelData(s));
            }
        }
    }
    public List<Dictionary<string, string>> CreateExcelData(ISheet sheet)
    {
        List<Dictionary<string, string>> _create = new List<Dictionary<string, string>>();
        IRow titleRow = sheet.GetRow(0);

        var _var = sheet.GetRowEnumerator();
        _var.MoveNext();
        while (_var.MoveNext())
        {
            if (titleRow == null)
                continue;

            IRow dataRow = (IRow)_var.Current;
            Dictionary<string, string> _rowList = new Dictionary<string, string>();
            for (int i = 0; i < titleRow.LastCellNum; i++)
            {
                ICell _rowCell = titleRow.GetCell(i);
                if (null == _rowCell)
                    continue;

                string _key = _rowCell.StringCellValue;
                if (_key == null || _key.Length <= 0)
                    continue;
                string _data = string.Empty;

                if (dataRow != null)
                {
                    ICell _cell = dataRow.GetCell(i);
                    if (null != _cell)
                    {
                        switch (_cell.CellType)
                        {
                            case CellType.Boolean:
                                _data = _cell.BooleanCellValue.ToString();
                                break;

                            case CellType.Numeric:
                                _data = _cell.NumericCellValue.ToString();
                                break;

                            case CellType.String:
                                _data = _cell.StringCellValue;
                                break;
                        }

                    }
                }
                _rowList.Add(_key.ToLower(), _data);
            }
            _create.Add(_rowList);
        }
        return _create;
    }
}
