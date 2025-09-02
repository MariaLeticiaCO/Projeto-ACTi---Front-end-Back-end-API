using Microsoft.AspNetCore.Mvc;
using System.Data;
using System.Data.SqlClient;
using ParceirosAPI.Models; 

namespace ParceirosAPI.Controllers
{
    [ApiController] 
    [Route("[controller]")] 
    public class ParceirosController : ControllerBase 
    {
        private readonly IConfiguration _configuration; 
        public ParceirosController(IConfiguration configuration)
        {
            _configuration = configuration; 
        }

        [HttpPost] 
        public IActionResult PostParceiro([FromBody] Parceiro parceiro) 
        {
            try
            {
                using var connection = new SqlConnection(_configuration.GetConnectionString("SqlServer")); 
                using var command = new SqlCommand("sp_inserir_parceiro", connection); 
                command.CommandType = System.Data.CommandType.StoredProcedure; 

                command.Parameters.AddWithValue("@Personalidade", parceiro.Personalidade);
                command.Parameters.AddWithValue("@RazaoSocial", parceiro.RazaoSocial);
                command.Parameters.AddWithValue("@CNPJ_CPF", parceiro.CNPJ_CPF);
                command.Parameters.AddWithValue("@CEP", parceiro.CEP);
                command.Parameters.AddWithValue("@UF", parceiro.UF);
                command.Parameters.AddWithValue("@Municipio", parceiro.Municipio);
                command.Parameters.AddWithValue("@Logradouro", parceiro.Logradouro);
                command.Parameters.AddWithValue("@Numero", parceiro.Numero);
                command.Parameters.AddWithValue("@Bairro", parceiro.Bairro);
                command.Parameters.AddWithValue("@Email", parceiro.Email);
                command.Parameters.AddWithValue("@Telefone", parceiro.Telefone);
                command.Parameters.AddWithValue("@Complemento", (object?)parceiro.Complemento ?? DBNull.Value);
                command.Parameters.AddWithValue("@Observacao", (object?)parceiro.Observacao ?? DBNull.Value);

                connection.Open(); 
                var reader = command.ExecuteReader(); 
                if (reader.Read())
                {
                    return Ok(new
                    {
                        NovoId = reader["NovoId"],
                        Mensagem = reader["Mensagem"]
                    }); 
                }
                return BadRequest("Erro ao cadastrar parceiro.");
            }
            catch (SqlException ex) 
            {
                return BadRequest(new { Erro = ex.Message });

            }
        }
    }
}
        
