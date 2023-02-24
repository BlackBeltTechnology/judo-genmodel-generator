package hu.blackbelt.judo.eclipse.emf.genmodel.generator.runtimemodel

import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtext.generator.GeneratorComponent.Outlet
import org.eclipse.xtext.mwe.ResourceLoadingSlotEntry
import org.eclipse.emf.mwe2.runtime.workflow.AbstractCompositeWorkflowComponent
import hu.blackbelt.judo.eclipse.emf.genmodel.generator.runtimemodel.engine.RuntimeModelGeneratorStandaloneSetup
import hu.blackbelt.judo.eclipse.emf.genmodel.generator.runtimemodel.engine.RuntimeModelGeneratorConfig
import java.util.List
import java.util.ArrayList

@Accessors
class RuntimeModelGeneratorWorkflow extends AbstractCompositeWorkflowComponent {
	
	String javaGenPath
	String modelDir
	String slot = "runtimeModelGenerator"
	Boolean printXmlOnError = false
	String resolveModelName = ""
	String resolveModelVersion = ""
	List<String> genModelNames = new ArrayList();
	
	
    def addGenModelName(String name) {
		genModelNames.add(name);
	}
	
	override preInvoke() {
		val slotEntry = new ResourceLoadingSlotEntry() => [
			setSlot(slot)
		]
		
		val config = new RuntimeModelGeneratorConfig() => [
			setJavaGenPath(javaGenPath)
			setPrintXmlOnError(printXmlOnError)
			setResolveModelName(resolveModelName)
			setResolveModelVersion(resolveModelVersion)
			setGenModelNames(genModelNames)
		]
		
		val setup = new RuntimeModelGeneratorStandaloneSetup() => [
			setConfig(config)
			setDoInit(true)
		]

		val readerComponent = new org.eclipse.xtext.mwe.Reader() => [
			addRegister(setup)
			addPath(modelDir)
			addLoadResource(slotEntry)
		]
		
		val outlet = new Outlet() => [
            setPath(javaGenPath)
        ]
		
		val generatorComponent = new org.eclipse.xtext.generator.GeneratorComponent() => [
			setRegister(setup)
			addSlot(slot)
			addOutlet(outlet)
		]

		addComponent(readerComponent)
		addComponent(generatorComponent)
		super.preInvoke
	}
}
