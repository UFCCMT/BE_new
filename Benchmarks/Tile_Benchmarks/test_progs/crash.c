

int main()
{
  int arr[10];
  int count;
  for(count=0; count<5; count++) //Will cause seg fault
    arr[count]=1;
}
