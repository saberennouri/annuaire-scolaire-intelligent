

package tn.itsfax.annuaire_scolaire_api.dto.response;

import java.time.LocalDateTime;

public record ApiStatusResponse(
        String application,
        String status,
        String message,
        LocalDateTime timestamp
) {
}
