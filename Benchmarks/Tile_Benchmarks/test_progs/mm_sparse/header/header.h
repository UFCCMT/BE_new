#define DATA_TYPE float

typedef
struct CSR
{
  int n_elems, n_nz_rows;
  DATA_TYPE *elems;
  int row_index;
  int column index;
}CSR;



void convert_matrix_to_CSR(DATA_TYPE*, int, int, CSR*);
void destroy_CSR(CSR*);
