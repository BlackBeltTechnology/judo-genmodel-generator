package hu.blackbelt.judo.eclipse.emf.genmodel.generator.runtimemodel.templates;

import javax.inject.Inject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.IGenerator

class RuntimeModelGenerator implements IGenerator {
    @Inject RuntimeModel runtimeModel
    // add more templates here

    override doGenerate(Resource input, IFileSystemAccess fsa) {
        runtimeModel.doGenerate(input,fsa)
    }
}