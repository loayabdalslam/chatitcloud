import * as React from 'react'
import { Box, Text } from '../ink.js'
import { Select } from './CustomSelect/select.js'
import type { CommandResultDisplay } from '../commands.js'

export interface ProviderSelectorProps {
  onSelect: (provider: 'anthropic' | 'opencode' | 'openrouter' | 'skip') => void
  onDone?: () => void
}

export function ProviderSelector({ onSelect, onDone }: ProviderSelectorProps): React.ReactNode {
  const providers = [
    {
      name: 'Anthropic (API key required)',
      value: 'anthropic' as const,
      description: 'Use your Anthropic API key for Claude models',
    },
    {
      name: 'OpenCode (local server)',
      value: 'opencode' as const,
      description: 'Connect to local OpenCode server with 75+ providers',
    },
    {
      name: 'OpenRouter (free tier)',
      value: 'openrouter' as const,
      description: 'Use free tier models (Gemini Flash, Mistral, Llama, Qwen)',
    },
    {
      name: 'Skip for now',
      value: 'skip' as const,
      description: 'Configure later with /provider command',
    },
  ]

  return (
    <Box flexDirection="column" paddingLeft={1} gap={1}>
      <Box flexDirection="column" gap={0}>
        <Text bold>Choose your AI provider:</Text>
        <Text dimColor wrap="wrap">
          Select where your AI models come from. You can change this later with{' '}
          <Text bold>/provider</Text>.
        </Text>
      </Box>

      <Select
        options={providers.map(p => ({
          label: p.name,
          value: p.value,
        }))}
        onSelect={(value: 'anthropic' | 'opencode' | 'openrouter' | 'skip') => {
          onSelect(value)
          if (onDone) {
            onDone()
          }
        }}
      />
    </Box>
  )
}
