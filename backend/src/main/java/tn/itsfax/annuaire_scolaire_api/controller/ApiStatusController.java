
package tn.itsfax.annuaire_scolaire_api.controller;


import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import tn.itsfax.annuaire_scolaire_api.dto.response.ApiStatusResponse;

import java.time.LocalDateTime;

@RestController
@RequestMapping("/api/v1/status")
public class ApiStatusController {

    @GetMapping
    public ApiStatusResponse getStatus() {
        return new ApiStatusResponse(
                "Annuaire Scolaire Intelligent",
                "UP",
                "L'API REST fonctionne correctement.",
                LocalDateTime.now()
        );
    }
}
