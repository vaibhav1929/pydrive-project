class Test{
  int[] arr = {13,45,23,7,15,6,3,2};

  int divide(int low,int high,int pivot){
    int i = low,j = high-1;
    System.out.println("J:"+j);

    while(true){


      while(arr[i]<pivot)
      {
        i++;
      }
            while(j>0 && arr[j]>pivot)
            {
              j--;
            }

      if(i < j){//swap arr[i] and arr[j]
        int temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
      }

      else if(i >= j){//swap pivot and arr[j]
        int temp = arr[i];
        arr[i] = arr[high];
        arr[high] = temp;
        break;
      }
    }
    return i;
  }

  void sort(int low,int high){
    if(low < high){
      int pivot = arr[high];
      System.out.println("Pivot:"+pivot);

      int mid = divide(low,high,pivot);
      sort(low,mid-1);//sort left array
      sort(mid+1,high);//sort right array
    }
  }
  public static void main(String[] args) {
    QuickSort q = new QuickSort();
    for(int t : q.arr){
      System.out.println(t);
    }
    q.sort(0,q.arr.length-1);
    System.out.println("SORTED---");
    for(int t : q.arr){
      System.out.println(t);
    }
  }
}
