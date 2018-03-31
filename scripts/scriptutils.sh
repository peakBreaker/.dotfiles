SUCCESS()
{
  echo -n '\e[32m'
  echo $1
  echo -n '\e[37m'
}

WARN()
{
  echo -n '\e[33m'
  echo $1
  echo -n '\e[37m'
}

ERROR()
{
  echo -n '\e[31m'
  echo $1
  echo -n '\e[37m'
}
