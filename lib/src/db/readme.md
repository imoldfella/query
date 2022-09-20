tabstyle {
  sql: ''
  }

spreadsheet:
  create table (id, tab, tabstyle)
  create table cell (id, tab, key, variant)  #key=rowId+colId
  create table float (id, tab, row, offset , variant)

document:
  

dirty reads allows reading uncommitted transactions. Transactions are only 

