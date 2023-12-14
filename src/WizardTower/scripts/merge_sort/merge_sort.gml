function merge_sort(_array, _priority_index){
  // [ _array ] is an array with each element being a sub-array.
  // [ _priority_index ] determines which element of the sub-array to use in sorting _array
  // returns a sorted version of _array
  
  // returns the sorted array, called '_array'
  if(array_length(_array) > 1)
  {
    // Divide the list into two halves.
    var mid = array_length(_array) div 2;
    var L = [];
    var R = [];
    array_copy(L,0,_array,0,mid);
    array_copy(R,0,_array,mid,array_length(_array)-mid);
	
    // Recursively sort the two halves.
    merge_sort(L, _priority_index);
    merge_sort(R, _priority_index);

    // Merge the two sorted halves into the original list.
    var i=0, j=0, k=0;
    while(i < array_length(L)) && (j < array_length(R))
	{
		if(L[i][_priority_index] < R[j][_priority_index])
		{
			_array[k] = L[i];
			i++;
		} else {
			_array[k] = R[j];
			j++;
		}
		k++;
	}
    // Copy the remaining elements from the left half, if any.
    while(i < array_length(L))
	{
		_array[k] = L[i]
		i++;
		k++;
	}
    // Copy the remaining elements from the right half, if any.
    while(j < array_length(R))
	{
		_array[k] = R[j]
		j++;
		k++;
	}
  }
  return _array;	
}
