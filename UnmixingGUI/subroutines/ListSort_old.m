function listNew = ListSort(list)
[listNew.value,I] = sort(list.value);
listNew.location1 = list.location1(I);
listNew.location2 = list.location2(I);