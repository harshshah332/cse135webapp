package cell;

public class Cell {
  private String prodName;
  private String stateName;
  private float origvalue;
  private int cellId;
  private int rowId;
  private int colId;
  private int cellType;
  
  public Cell(){
	  prodName = "";
	  origvalue = 0;
	  cellId = 0;
	  
	  rowId = 0;
	  colId = 0;
    cellType = 4; //1=product, 2=state, 3=tablecell, 4=default
	  	  
  }
  
  public Cell(String pName, float oValue, int cell, int row, int col, String statename, int type ) {
	  super();
	  this.prodName = pName;
	  this.origvalue = oValue;
	  this.cellId = cell;
	  this.rowId = row;
	  this.colId = col;
	  this.stateName = statename;
    this.cellType = type;
	  
  }
  
  public String getProdName(){
	  return prodName;
  }
  
  public String getstateName(){
	  return stateName;
  }
  
  
  public void setProdName(String pName){
	  prodName = pName;
  }
  
  public float getOrigVal(){
	  return origvalue;
  }
  
  public void setOrigVal(float oVal){
	  origvalue = oVal;
  }
  
  public int getCellId(){
	  return cellId;
  }
  
  public void setCellId(int cell){
	  cellId = cell;
  }
  
  public int getRowId(){
	  return rowId;
  }
  
  public void setRowId(int row){
	  rowId = row;
  }
  
  public int getColId(){
	  return colId;
  }
  
  public void setColId(int col){
	  colId = col;
  }

  public int getCellType(){
    return cellType;
  }
  
  public void setCellType(int type){
    cellType = type;
  }
  
}
