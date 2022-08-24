using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

namespace Microsoft.DSX.ProjectTemplate.Data
{
    public class ProjectTemplateDbContextFactory : IDesignTimeDbContextFactory<ProjectTemplateDbContext>
    {
        public ProjectTemplateDbContext CreateDbContext(string[] args)
        {
            var optionsBuilder = new DbContextOptionsBuilder<ProjectTemplateDbContext>();
            optionsBuilder.UseSqlServer("Server=tcp:demo-sql-weu-backend.database.windows.net,1433;Initial Catalog=sqldatabasebackend1;Persist Security Info=False;User ID=4dm1n157r470r;Password=v-:a%pbjPQx#)<w};MultipleActiveResultSets=True;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;");
            return new ProjectTemplateDbContext(optionsBuilder.Options);
        }
    }
}
