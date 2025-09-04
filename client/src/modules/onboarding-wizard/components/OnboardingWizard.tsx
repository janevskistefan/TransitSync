import { useState } from 'react';
import { onboardingSteps } from './OnboardingSteps';
import { Box, Button, Step, StepLabel, Stepper } from '@mui/material';
import { useForm } from 'react-hook-form';

export const OnboardingWizard = () => {

  const form = useForm()

  const [activeStep, setActiveStep] = useState(onboardingSteps[0]);

  const activeStepIndex = onboardingSteps.findIndex(
    (step) => step.id === activeStep.id,
  );

  const handleNext = () => {
    const nextStepIndex = activeStepIndex + 1;
    if (nextStepIndex < onboardingSteps.length) {
      setActiveStep(onboardingSteps[nextStepIndex]);
    } else {
      console.log('Wizard finished!');
    }
  };

  const handleBack = () => {
    const prevStepIndex = activeStepIndex - 1;
    if (prevStepIndex >= 0) {
      setActiveStep(onboardingSteps[prevStepIndex]);
    }
  };

  return (
    <Box padding={8}>
      <Stepper alternativeLabel activeStep={activeStepIndex}>
        {onboardingSteps.map((step) => (
          <Step key={step.id}>
            <StepLabel icon={<step.icon />}>{step.title}</StepLabel>
          </Step>
        ))}
      </Stepper>
      {<activeStep.component />}
      {/* TODO: Disable buttons when specific conditions are met. */}
      <Box display={'flex'} gap={1}>
        <Button variant="outlined" onClick={handleBack}>
          Back
        </Button>
        <Button variant="contained" onClick={handleNext}>
          Next
        </Button>
      </Box>
    </Box>
  );
};
