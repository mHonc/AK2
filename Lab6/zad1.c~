#include <stdlib.h>
#include <stdio.h>
#include <time.h> 
#define N 16

int tab1[N];
int tab2[N];
int temp1[N];
int temp2[N];

void add_C(int vec1[], int vec2[], int n);
extern void add_ASM(int vec1[], int vec2[],int n);
extern long long rdtsc(void);


int main()
{
long long start, end;
int n=N;
srand(time(NULL));
for(int i=0;i<N;i++)
{
  int x, y;
  x = rand()%100;
  y = rand()%100;
  tab1[i] = x;
  tab2[i] = y;
  temp1[i] = x;
  temp2[i] = y;
}

for(int i = 0; i < N; i++)
   printf("%d ", tab1[i]);
printf("\n");

for(int i = 0; i < N; i++)
   printf("%d ", tab2[i]);
printf("\n");

start = rdtsc();
add_C(temp1,temp2,n);
end = rdtsc();
printf("dodanie c  : %llu \n",start - end);

for(int i = 0; i < N; i++)
   printf("%d ", tab1[i]);
printf("\n");

start = rdtsc();
add_ASM(tab1,tab2,n);
end = rdtsc();
printf("dodanie asm: %llu \n",start - end);


for(int i = 0; i < N; i++)
   printf("%d ", tab1[i]);
printf("\n");

  return 0;
}

void add_C(int vec1[], int vec2[],int n)
{
  for(int i=0;i<n;i++)
  {
     vec1[i] = vec2[i] + vec1[i];
  }
}


