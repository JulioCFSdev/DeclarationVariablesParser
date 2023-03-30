#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <math.h>
#include <string.h>
#include <limits.h>

typedef struct NODO
{
   char tipo[10];
   int valor;
   long chave;
   char nome[100];
}nodo;

typedef struct nodo_table
{
   int sinal;
   nodo *dados;
}nodo_table;

int tam = 0;
int max = 50;
nodo_table *hash_table;

void hash_initialize()
{
  for (int e = 0; e < max; e++)
    {
      hash_table[e].sinal = 0;
      hash_table[e].dados = NULL;
    }

}

long Gera_chave(char name[100])
{
  long chave = 0;
  int carac_asc = 0;
  for (int e = 0; e < strlen(name); e++)
    {
      carac_asc = name[e];
      chave += carac_asc * pow(2, e);
    }
  return chave;
}

int Cod_hash(int chave)
{
  int ind = chave % max;
  return ind;
}

void hash_insert(char name[100], char type[10], int val)
{
  int index = Cod_hash(Gera_chave(name));
  
  int n_ind = index;
  
  nodo *n_elem = (nodo*) malloc(sizeof(nodo));
  n_elem -> valor = val;
  n_elem -> chave = Gera_chave(name);
  strncpy(n_elem -> nome, name, 100);
  strncpy(n_elem -> tipo, type, 10);

  while (hash_table[n_ind].sinal == 1)
    {
      if (hash_table[n_ind].dados -> chave == Gera_chave(name))
      {
        hash_table[n_ind].dados -> valor = val;
        printf("\nKey already created, now updated.\n");
        return;
      }

      n_ind = (n_ind + 1) % max;
      if (n_ind == index)
      {
        printf("\nHash table is full.\n");
        return;
      }
    }

  hash_table[n_ind].sinal = 1;
  hash_table[n_ind].dados = n_elem;
  tam++;
}

void Remover(char name[100])
{
  int index = Cod_hash(Gera_chave(name));
  int n_ind = index;

  while (hash_table[n_ind].sinal != 0)
    {

      if (hash_table[n_ind].sinal == 1 && hash_table[n_ind].dados -> chave == Gera_chave(name))
      {
        hash_table[n_ind].sinal = 2;
        hash_table[n_ind].dados = NULL;
        tam--;
        printf("\n %s removed.\n", name);
        return;
      }

      n_ind = (n_ind + 1) % max;

      if (n_ind == index)
      {
        break;
      }
    }

  printf("\n Key not found.\n");
}


nodo * Buscar(char name[100])
{
  int index = Cod_hash(Gera_chave(name));
  int n_ind = index;
  nodo * found;

  while (hash_table[n_ind].sinal != 0)
    {

      if (hash_table[n_ind].sinal == 1 && hash_table[n_ind].dados -> chave == Gera_chave(name))
      {
        found = hash_table[n_ind].dados;
        return found;
      }

      n_ind = (n_ind + 1) % max;

      if (n_ind == index)
      {
        break;
      }
    }

  found = NULL;
  
  return found;
}

nodo * hash_get_elem(char name[100])
{
  int index = Cod_hash(Gera_chave(name));
  nodo * atual = hash_table[index].dados;
  if (atual != NULL)
    return atual;
  
  return NULL;
}

int hash_get(char nom[100])
{
  int index = Cod_hash(Gera_chave(nom));
  long carac_asc, carac_aux;
  nodo * atual = hash_table[index].dados;
  if (atual ==  NULL)
  {
    printf("Variable not found...\n");
        return INT_MIN;
  }
  for (int e = 0; e < strlen(nom); e++)
    {
      carac_asc = nom[e];
      carac_aux = atual->nome[e];
      if (carac_asc != carac_aux)
      {
        printf("Variable not found...\n");
        return INT_MIN;
        }
    }
  return atual->valor;
}

void hash_update(char name[100], int val)
{
  int x = hash_get(name);
  
  if (x == INT_MIN)
    printf("Variable not found...\n");
  else
    hash_table[Cod_hash(Gera_chave(name))].dados->valor = val;
}