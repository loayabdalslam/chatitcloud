/**
 * Free tier models available through OpenRouter and other free providers.
 * These models can be used without an API key or with a free tier account.
 */

export interface FreeTierModel {
  id: string
  name: string
  provider: 'openrouter' | 'ollama' | 'google'
  requiresKey?: boolean
  description?: string
}

export const FREE_TIER_MODELS: FreeTierModel[] = [
  {
    id: 'google/gemini-flash-1.5',
    name: 'Gemini Flash 1.5 (Google)',
    provider: 'openrouter',
    description: 'Fast and efficient model from Google - free tier available',
    requiresKey: false,
  },
  {
    id: 'mistralai/mistral-7b-instruct',
    name: 'Mistral 7B Instruct (Mistral)',
    provider: 'openrouter',
    description: 'Capable open-source model - free tier available',
    requiresKey: false,
  },
  {
    id: 'meta-llama/llama-3-8b-instruct',
    name: 'Llama 3 8B Instruct (Meta)',
    provider: 'openrouter',
    description: 'Meta\'s Llama 3 open-source model - free tier available',
    requiresKey: false,
  },
  {
    id: 'qwen/qwen-2-7b-instruct',
    name: 'Qwen 2 7B Instruct (Alibaba)',
    provider: 'openrouter',
    description: 'High-performance Chinese model - free tier available',
    requiresKey: false,
  },
  {
    id: 'ollama-local',
    name: 'Ollama Local (self-hosted)',
    provider: 'ollama',
    description: 'Run models locally with Ollama - completely free',
    requiresKey: false,
  },
]

/**
 * Get free tier models filtered by provider
 */
export function getFreeTierModelsByProvider(provider: 'openrouter' | 'ollama' | 'google'): FreeTierModel[] {
  return FREE_TIER_MODELS.filter(model => model.provider === provider)
}

/**
 * Check if a model ID is a free tier model
 */
export function isFreeTierModel(modelId: string): boolean {
  return FREE_TIER_MODELS.some(model => model.id === modelId)
}
