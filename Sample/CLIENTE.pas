unit CLIENTE;

interface

type
  TCLIENTE = class
  private
    FCONSUMIDOR_FINAL: Integer;
    FCODIGO: Integer;
    FSTATUS: Integer;
    FLOGRADOURO: string;
    FNOME_FANTASIA: string;
    FIE: string;
    FNUMERO: string;
    FTELEFONE: string;
    FCELULAR: string;
    FCOMPLEMENTO: string;
    FCIDADE: string;
    FCEP: string;
    FRAZAO_SOCIAL: string;
    FCPF_CNPJ: string;
    FEMAIL: string;
    FBAIRRO: string;
    FUF: string;
    FIBGE: Integer;
    FIM: string;
    FDATA_CADASTRO: TDateTime;
    FDATA_NASCIMENTO: TDateTime;
    FTIPO_CONTRIBUINTE: Integer;
  published
    property CODIGO : Integer read FCODIGO write FCODIGO;
    property RAZAO_SOCIAL : string read FRAZAO_SOCIAL write FRAZAO_SOCIAL;
    property NOME_FANTASIA : string read FNOME_FANTASIA write FNOME_FANTASIA;
    property CPF_CNPJ : string read FCPF_CNPJ write FCPF_CNPJ;
    property TELEFONE : string read FTELEFONE write FTELEFONE;
    property CELULAR : string read FCELULAR write FCELULAR;
    property LOGRADOURO : string read FLOGRADOURO write FLOGRADOURO;
    property NUMERO : string read FNUMERO write FNUMERO;
    property COMPLEMENTO : string read FCOMPLEMENTO write FCOMPLEMENTO;
    property BAIRRO : string read FBAIRRO write FBAIRRO;
    property CIDADE : string read FCIDADE write FCIDADE;
    property CEP : string read FCEP write FCEP;
    property UF : string read FUF write FUF;
    property IBGE : Integer read FIBGE write FIBGE;
    property TIPO_CONTRIBUINTE : Integer read FTIPO_CONTRIBUINTE write FTIPO_CONTRIBUINTE;
    property IE : string read FIE write FIE;
    property IM : string read FIM write FIM;
    property EMAIL : string read FEMAIL write FEMAIL;
    property CONSUMIDOR_FINAL : Integer read FCONSUMIDOR_FINAL write FCONSUMIDOR_FINAL;
    property DATA_CADASTRO : TDateTime read FDATA_CADASTRO write FDATA_CADASTRO;
    property DATA_NASCIMENTO : TDateTime read FDATA_NASCIMENTO write FDATA_NASCIMENTO;
    property STATUS : Integer read FSTATUS write FSTATUS;
  end;

implementation

end.
