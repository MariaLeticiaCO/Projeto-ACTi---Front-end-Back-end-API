namespace ParceirosAPI.Models
{
    public class Parceiro 
    {
        
        public string Personalidade { get; set; }  
        public string RazaoSocial { get; set; } 
        public string CNPJ_CPF { get; set; }
        public string CEP { get; set; }
        public string UF { get; set; }
        public string Municipio { get; set; }
        public string Bairro { get; set; }
        public string? Complemento { get; set; }
        public string? Observacao { get; set; }
    }
}
