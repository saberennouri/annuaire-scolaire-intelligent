package tn.itsfax.annuaire_scolaire_api.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI annuaireOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("Annuaire Scolaire Intelligent API")
                        .description(
                                "API REST de consultation de l'annuaire scolaire de Sfax"
                        )
                        .version("1.0.0")
                        .contact(new Contact()
                                .name("Équipe Annuaire Scolaire")
                        )
                );
    }
}
