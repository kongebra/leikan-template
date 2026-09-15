import { createAuthClient } from "better-auth/client";
import { genericOAuthClient } from "better-auth/client/plugins";

// Klientside-instans for better-auth.
// Ingen baseURL: kallene går mot samme origin som siden, uavhengig av hvilken port Aspire eksponerer.
export const authClient = createAuthClient({
  plugins: [genericOAuthClient()],
});
