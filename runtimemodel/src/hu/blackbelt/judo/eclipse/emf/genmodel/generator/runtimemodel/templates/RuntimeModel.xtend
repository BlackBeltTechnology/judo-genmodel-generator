package hu.blackbelt.judo.eclipse.emf.genmodel.generator.runtimemodel.templates;

import javax.inject.Inject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.IGenerator
import org.eclipse.emf.codegen.ecore.genmodel.GenModel
import hu.blackbelt.eclipse.emf.genmodel.generator.core.engine.GeneratorConfig;

class RuntimeModel implements IGenerator {
	@Inject extension Naming
	@Inject GeneratorConfig config

	override doGenerate(Resource input, IFileSystemAccess fsa) {		
		input.allContents.filter(GenModel).forEach[
			val content = generate
			fsa.generateFile(packagePath + "/runtime/" + modelName + "Model.java", content)
		]
	}
	
	def generate (GenModel it) 
	'''
		package «packageName».runtime;
		
		import org.eclipse.emf.common.util.Diagnostic;
		import org.eclipse.emf.common.util.URI;
		import org.eclipse.emf.ecore.EObject;
		import org.eclipse.emf.ecore.resource.Resource;
		import org.eclipse.emf.ecore.resource.ResourceSet;
		import org.eclipse.emf.ecore.resource.URIHandler;
		
		import «packageName».support.«modelName»ModelResourceSupport;
		
		import java.io.*;
		import java.util.Collections;
		import java.util.Dictionary;
		import java.util.Hashtable;
		import java.util.Map;
		import java.util.Optional;
		import java.util.Set;
		
		import static «packageName».support.«modelName»ModelResourceSupport.setupRelativeUriRoot;
		import static java.util.Objects.requireNonNull;
		import static java.util.Optional.ofNullable;
		
				
		/**
		 * A wrapper class on a «modelName» metamodel based model. This wrapper organizing the model a structure which can be used
		 * in Tatami as a logical model.
		 * The logical model have version and loaded resources. The logical model can handle load and save from / to different
		 * type of input / output source.
		 *
		 * Examples:
		 *
		 * Load an model from file.
		 * <pre>
		 *    «modelName»Model «modelName.decapitalize»Model = «modelName»Model.load«modelName»Model(«modelName.decapitalize»LoadArgumentsBuilder()
		 *                 .uri(URI.createFileURI(new File("src/test/model/test.«modelName.decapitalize»").getAbsolutePath()))
		 *                 .name("test")
		 *                 .build());
		 *
		 * </pre>
		 *
		 * More complex example, where model is loaded over an {@link URIHandler} in OSGi environment.
		 *
		 * <pre>
		 *
		 *    BundleURIHandler bundleURIHandler = new BundleURIHandler("urn", "", bundleContext.getBundle());
		 *
		 *    «modelName»Model «modelName.decapitalize»Model = «modelName»Model.build«modelName»Model()
		 *                 .name("test")
		 *                 .version("1.0.0")
		 *                 .uri(URI.createURI("urn:test.«modelName.decapitalize»"))
		 *                 .uriHandler(bundleURIHandler)
		 *                 .metaVersionRange(bundleContext.getBundle().getHeaders().get("[1.0,2))).build();
		 * </pre>
		 *
		 * Create an empty «modelName.decapitalize» model
		 * <pre>
		 *    «modelName»Model «modelName.decapitalize»Model = «modelName»Model.build«modelName»Model()
		 *                 .name("test")
		 *                 .uri(URI.createFileURI("test.model"))
		 *                 .build()
		 * </pre>
		 *
		 */
		public class «modelName»Model {
		
		    public static final String NAME = "name";
		    public static final String VERSION = "version";
		    public static final String CHECKSUM = "checksum";
		    public static final String META_VERSION_RANGE = "meta-version-range";
		    public static final String URI = "uri";
		    public static final String RESOURCESET = "resourceset";
		    public static final String TAGS = "tags";
		
		    private String name;
		    private String version;
		    private URI uri;
		    private String checksum;
		    private String metaVersionRange;
		    private «modelName»ModelResourceSupport «modelName.decapitalize»ModelResourceSupport;
		    private Set<String> tags;
		
		    /**
		     * Return all properties as a {@link Dictionary}
		     * @return
		     */
		    public Dictionary<String, Object> toDictionary() {
		        Dictionary<String, Object> ret = new Hashtable<>();
		        ret.put(NAME, name);
		        ret.put(VERSION, version);
		        ret.put(URI, uri);
		        ret.put(CHECKSUM, checksum);
		        ret.put(META_VERSION_RANGE, metaVersionRange);
		        ret.put(RESOURCESET, «modelName.decapitalize»ModelResourceSupport.getResourceSet());
		        ret.put(TAGS, tags);
		        return ret;
		    }
		
		    /**
		     * Get the model's isolated {@link ResourceSet}
		     * @return instance of {@link ResourceSet}
		     */
		    public ResourceSet getResourceSet() {
		        return «modelName.decapitalize»ModelResourceSupport.getResourceSet();
		    }
		
		
		    /**
		     * Get the model's root resource which represents the mdoel's uri {@link URI} itself.
		     * If the given resource does not exists new one is created.
		     * @return instance of {@link Resource}
		     */
		    public Resource getResource() {
		        if (getResourceSet().getResource(uri, false) == null) {
		            getResourceSet().createResource(uri);
		        }
		        return getResourceSet().getResource(uri, false);
		    }
		
		    /**
		     * Add content to the given model's root.
		     * @param object Object to add to resource.
		     * @return return this instance
		     */
		    @SuppressWarnings("UnusedReturnValue")
		    public «modelName»Model addContent(EObject object) {
		        getResource().getContents().add(object);
		        return this;
		    }
		
		    /**
		     * Load an model into {@link «modelName»Model} default {@link Resource}.
		     * The {@link URI}, {@link URIHandler} and {@link ResourceSet} arguments are not used here, because it has
		     * already set.
		     * @param loadArgumentsBuilder {@link LoadArguments.LoadArgumentsBuilder} used for load.
		     * @return this {@link «modelName»ModelResourceSupport}
		     * @throws IOException when IO error occured
		     * @throws «modelName»ValidationException when model validation is true and the model is invalid.
		     */
		    public «modelName»Model loadResource(LoadArguments.LoadArgumentsBuilder
		                                                        loadArgumentsBuilder)
		            throws IOException, «modelName»ValidationException {
		        return loadResource(loadArgumentsBuilder.build());
		    }
		
		    /**
		     * Load an model into {@link «modelName»Model} default {@link Resource}.
		     * The {@link URI}, {@link URIHandler} and {@link ResourceSet} arguments are not used here, because it has
		     * already set.
		     * @param loadArguments {@link LoadArguments} used for load.
		     * @return this {@link «modelName»ModelResourceSupport}
		     * @throws IOException when IO error occured
		     * @throws «modelName»ValidationException when model validation is true and the model is invalid.
		     */
		    @SuppressWarnings("WeakerAccess")
		    public «modelName»Model loadResource(LoadArguments loadArguments)
		            throws IOException, «modelName»ValidationException {
		
		        Resource resource = getResource();
		        Map loadOptions = loadArguments.getLoadOptions()
		                .orElseGet(«modelName»ModelResourceSupport::get«modelName»ModelDefaultLoadOptions);
		
		        try {
		            InputStream inputStream = loadArguments.getInputStream()
		                    .orElseGet(() -> loadArguments.getFile().map(f -> {
		                        try {
		                            return new FileInputStream(f);
		                        } catch (FileNotFoundException e) {
		                            throw new RuntimeException(e);
		                        }
		                    }).orElse(null));
		
		            if (inputStream != null) {
		                resource.load(inputStream, loadOptions);
		            } else {
		                resource.load(loadOptions);
		            }
		
		        } catch (RuntimeException e) {
		            if (e.getCause() instanceof IOException) {
		                throw (IOException) e.getCause();
		            } else {
		                throw e;
		            }
		        }
		
		        if (loadArguments.isValidateModel() && !isValid()) {
		            throw new «modelName»ValidationException(this);
		        }
		        return this;
		    }
		
		    /**
		     * Load an model. {@link LoadArguments.LoadArgumentsBuilder} contains all parameter
		     * @param loadArgumentsBuilder {@link LoadArguments.LoadArgumentsBuilder} used for load
		     * @return new {@link «modelName»Model} instance
		     * @throws IOException when IO error occured
		     * @throws «modelName»ValidationException when model validation is true and the model is invalid.
		     */
		    public static «modelName»Model load«modelName»Model(LoadArguments.LoadArgumentsBuilder loadArgumentsBuilder)
		            throws IOException, «modelName»ValidationException {
		        return load«modelName»Model(loadArgumentsBuilder.build());
		    }
		
		    /**
		     * Load an model. {@link LoadArguments} contains all parameter
		     * @param loadArguments {@link LoadArguments.LoadArgumentsBuilder} used for load
		     * @return new {@link «modelName»Model} instance.
		     * @throws IOException when IO error occured
		     * @throws «modelName»ValidationException when model validation is true and the model is invalid.
		     */
		    public static «modelName»Model load«modelName»Model(LoadArguments loadArguments) throws IOException, «modelName»ValidationException {
		        try {
		            «modelName»ModelResourceSupport «modelName.decapitalize»ModelResourceSupport = «modelName»ModelResourceSupport
		                    .load«modelName»(loadArguments.to«modelName»ModelResourceSupportLoadArgumentsBuilder()
		                            .validateModel(false));
		            «modelName»Model «modelName.decapitalize»Model = build«modelName»Model()
		                    .name(loadArguments.getName()
		                            .orElseThrow(() -> new IllegalArgumentException("Name is mandatory")))
		                    .version(loadArguments.getVersion()
		                            .orElse("1.0.0"))
		                    .uri(loadArguments.getUri()
		                            .orElseGet(() ->
		                                    org.eclipse.emf.common.util.URI.createURI(
		                                            loadArguments.getName().get() + "-«modelName.decapitalize».model")))
		                    .checksum(loadArguments.getChecksum()
		                            .orElse("NON-DEFINED"))
		                    .tags(loadArguments.getTags()
		                            .orElse(Collections.emptySet()))
		                    .«modelName.decapitalize»ModelResourceSupport(«modelName.decapitalize»ModelResourceSupport)
		                    .metaVersionRange(loadArguments.getAcceptedMetaVersionRange()
		                            .orElse("[0,9999)"))
		                    .build();
		
		            setupRelativeUriRoot(«modelName.decapitalize»Model.getResourceSet(), loadArguments.uri);
		
		            if (loadArguments.validateModel && !«modelName.decapitalize»ModelResourceSupport.isValid()) {
		                throw new «modelName»ValidationException(«modelName.decapitalize»Model);
		            }
		            return «modelName.decapitalize»Model;
		
		        } catch («modelName»ModelResourceSupport.«modelName»ValidationException ignore) {
		            throw new IllegalStateException("This exception generated because the code is broken");
		        }
		    }
		
		    /**
		     * Save the model to the given URI.
		     * @throws IOException when IO error occurred
		     * @throws «modelName»ValidationException when model validation is true and the model is invalid.
		     */
		    public void save«modelName»Model() throws IOException, «modelName»ValidationException {
		        save«modelName»Model(SaveArguments.«modelName.decapitalize»SaveArgumentsBuilder());
		    }
		
		    /**
		     * Save the model as the given {@link SaveArguments.SaveArgumentsBuilder} defines
		     * @param saveArgumentsBuilder the {@link SaveArguments.SaveArgumentsBuilder} used for save
		     * @throws IOException when IO error occurred
		     * @throws «modelName»ValidationException when model validation is true and the model is invalid.
		     */
		    public void save«modelName»Model(SaveArguments.SaveArgumentsBuilder saveArgumentsBuilder)
		            throws IOException, «modelName»ValidationException {
		        save«modelName»Model(saveArgumentsBuilder.build());
		    }
		
		    /**
		     * Save the model as the given {@link SaveArguments} defines
		     * @param saveArguments the {@link SaveArguments} used for save
		     * @throws IOException when IO error occurred
		     * @throws «modelName»ValidationException when model validation is true and the model is invalid.
		     */
		    public void save«modelName»Model(SaveArguments saveArguments) throws IOException, «modelName»ValidationException {
		        if (saveArguments.validateModel && !«modelName.decapitalize»ModelResourceSupport.isValid()) {
		            throw new «modelName»ValidationException(this);
		        }
		        try {
		            «modelName.decapitalize»ModelResourceSupport.save«modelName»(saveArguments.to«modelName»ModelResourceSupportSaveArgumentsBuilder()
		                    .validateModel(false));
		        } catch («modelName»ModelResourceSupport.«modelName»ValidationException e) {
		            // Validation disaled, this exception cannot be thrown
		        }
		    }
		
		    /**
		     * Get distinct diagnostics for model. Only  {@link Diagnostic}.WARN and {@link Diagnostic}.ERROR are returns.
		     * @return set of {@link Diagnostic}
		     */
		    public Set<Diagnostic> getDiagnostics() {
		        return «modelName.decapitalize»ModelResourceSupport.getDiagnostics();
		    }
		
		    /**
		     * Checks the model have any {@link Diagnostic}.ERROR diagnostics. When there is no any the model assumed as valid.
		     * @return true when model is valid
		     */
		    public boolean isValid() {
		        return «modelName.decapitalize»ModelResourceSupport.isValid();
		    }
		
		    /**
		     * Print model as string
		     * @return model as XML string
		     */
		    @SuppressWarnings("WeakerAccess")
		    public String asString() {
		        return «modelName.decapitalize»ModelResourceSupport.asString();
		    }
		
		    /**
		     * Get diagnostics as a String
		     * @return diagnostic list as string. Every line represents one diagnostic.
		     */
		    @SuppressWarnings("WeakerAccess")
		    public String getDiagnosticsAsString() {
		        return «modelName.decapitalize»ModelResourceSupport.getDiagnosticsAsString();
		    }
		
		    /**
		     * This exception is thrown when validateModel is true on load or save and the model is not conform with its
		     * defined metamodel.
		     */
		    @SuppressWarnings("WeakerAccess")
		    public static class «modelName»ValidationException extends Exception {
		        «modelName»Model «modelName.decapitalize»Model;
		
		        public «modelName»ValidationException(«modelName»Model «modelName.decapitalize»Model) {
		            «IF config.printXmlOnError»
		                super("Invalid model\n" +
		                        «modelName.decapitalize»Model.getDiagnosticsAsString() + "\n" +
		                        «modelName.decapitalize»Model.asString());
		            «ELSE»
		                super("Invalid model\n" + «modelName.decapitalize»Model.getDiagnosticsAsString());
		            «ENDIF»
		            this.«modelName.decapitalize»Model = «modelName.decapitalize»Model;
		        }
		    }
		
		    /**
		     * Arguments for {@link «modelName»Model#load«modelName»Model(LoadArguments)}
		     * It can handle variance of the presented arguments.
		     */
		    public static class LoadArguments {
		        URI uri;
		        String name;
		        URIHandler uriHandler;
		        ResourceSet resourceSet;
		        String version;
		        String checksum;
		        String acceptedMetaVersionRange;
		        Map<Object, Object> loadOptions;
		        boolean validateModel;
		        InputStream inputStream;
		        File file;
		        Set<String> tags;
		
		        private static URIHandler $default$uriHandler() {
		            return null;
		        }
		
		        private static ResourceSet $default$resourceSet() {
		            return null;
		        }
		
		        private static String $default$version() {
		            return "1.0.0";
		        }
		
		        private static String $default$checksum() {
		            return "NOT-SET";
		        }
		
		        private static String $default$acceptedMetaVersionRange() {
		            return "[0,9999]";
		        }
		
		        private static File $default$file() {
		            return null;
		        }
		
		        private static InputStream $default$inputStream() {
		            return null;
		        }

		        private static Set<String> $default$tags() {
		            return  Collections.emptySet();
		        }
		
		        private static Map<Object, Object> $default$loadOptions() {
		            return «modelName»ModelResourceSupport.get«modelName»ModelDefaultLoadOptions();
		        }
		
		        Optional<URI> getUri() {
		            return ofNullable(uri);
		        }
		
		        Optional<String> getName() {
		            return ofNullable(name);
		        }
		
		        Optional<URIHandler> getUriHandler() {
		            return ofNullable(uriHandler);
		        }
		
		        Optional<ResourceSet> getResourceSet() {
		            return ofNullable(resourceSet);
		        }
		
		        Optional<String> getVersion() {
		            return ofNullable(version);
		        }
		
		        Optional<String> getChecksum() {
		            return ofNullable(checksum);
		        }
		
		        Optional<String> getAcceptedMetaVersionRange() {
		            return ofNullable(acceptedMetaVersionRange);
		        }

		        Optional<Set<String>> getTags() {
		            return ofNullable(tags);
		        }
		
		        Optional<Map<Object, Object>> getLoadOptions() {
		            return ofNullable(loadOptions);
		        }
		
		        boolean isValidateModel() {
		            return validateModel;
		        }
		
		        Optional<File> getFile() {
		            return ofNullable(file);
		        }
		
		        Optional<InputStream> getInputStream() {
		            return ofNullable(inputStream);
		        }
		
		        /**
		         * Builder for {@link «modelName»Model#load«modelName»Model(LoadArguments)}.
		         */
		        public static class LoadArgumentsBuilder {
		            private URI uri;
		            private String name;
		
		            private boolean uriHandler$set;
		            private URIHandler uriHandler;
		            
		            private boolean resourceSet$set;
		            private ResourceSet resourceSet;
		            
		            private boolean version$set;
		            private String version;
		            
		            private boolean checksum$set;
		            private String checksum;
		            
		            private boolean acceptedMetaVersionRange$set;
		            private String acceptedMetaVersionRange;

		            private boolean tags$set;
		            private Set<String> tags;
		            
		            private boolean loadOptions$set;
		            private Map<Object, Object> loadOptions;
		
		            private boolean validateModel = true;
		
		            private boolean file$set;
		            private File file;
		
		            
		            private boolean inputStream$set;
		            private InputStream inputStream;
		
		            
		            LoadArgumentsBuilder() {
		            }
		
		            /**
		             * Defines the {@link URI} of the model.
		             * This is mandatory.
		             */
		            public LoadArgumentsBuilder uri(final URI uri) {
		                requireNonNull(uri);
		                this.uri = uri;
		                return this;
		            }
		
		            
		            /**
		             * Defines the name of the model.
		             * This is mandatory.
		             */
		            public LoadArgumentsBuilder name(final String name) {
		                requireNonNull(name);
		                this.name = name;
		                return this;
		            }
		
		            /**
		             * Defines the {@link URIHandler} used for model IO. If not defined the default is EMF used.
		             */
		            public LoadArgumentsBuilder uriHandler(final URIHandler uriHandler) {
		                requireNonNull(uriHandler);
		                this.uriHandler = uriHandler;
		                uriHandler$set = true;
		                return this;
		            }
		
		            
		            /**
		             * Defines the default {@link ResourceSet}. If it is not defined the factory based resourceSet is used.
		             */
		            public LoadArgumentsBuilder resourceSet(final ResourceSet resourceSet) {
		                requireNonNull(resourceSet);
		                this.resourceSet = resourceSet;
		                resourceSet$set = true;
		                return this;
		            }
		
		            
		            /**
		             * Defines the model version. If its not defined the version will be 1.0.0
		             */
		            public LoadArgumentsBuilder version(final String version) {
		                requireNonNull(version);
		                this.version = version;
		                version$set = true;
		                return this;
		            }
		
		            
		            /**
		             * Defines the model checksum. If its not defined 'notused' is defined.
		             */
		            public LoadArgumentsBuilder checksum(final String checksum) {
		                requireNonNull(checksum);
		                this.checksum = checksum;
		                checksum$set = true;
		                return this;
		            }
		
		            
		            /**
		             * Defines the accepted version range of the meta model. If its not defined [1.0,999) is used.
		             */
		            public LoadArgumentsBuilder acceptedMetaVersionRange(final String acceptedMetaVersionRange) {
		                requireNonNull(acceptedMetaVersionRange);
		                this.acceptedMetaVersionRange = acceptedMetaVersionRange;
		                acceptedMetaVersionRange$set = true;
		                return this;
		            }

		            /**
		             * Defines the tags of mdoel.
		             */
		            public LoadArgumentsBuilder tags(final Set<String> tags) {
		                requireNonNull(tags);
		                this.tags = tags;
		                tags$set = true;
		                return this;
		            }
		
		            
		            /**
		             * Defines the load options for model. If not defined the
		             * {@link «modelName»ModelResourceSupport#get«modelName»ModelDefaultLoadOptions()} us used.
		             */
		            public LoadArgumentsBuilder loadOptions(final Map<Object, Object> loadOptions) {
		                requireNonNull(loadOptions);
		                this.loadOptions = loadOptions;
		                loadOptions$set = true;
		                return this;
		            }
		
		            
		            /**
		             * Defines that model validation required or not on load. Default: true
		             */
		            public LoadArgumentsBuilder validateModel(boolean validateModel) {
		                this.validateModel = validateModel;
		                return this;
		            }
		
		            
		            /**
		             * Defines the file if it is not loaded from URI. If not defined, URI is used. If inputStream is defined
		             * it is used.
		             */
		            public LoadArgumentsBuilder file(final File file) {
		                requireNonNull(file);
		                this.file = file;
		                file$set = true;
		                return this;
		            }
		
		            
		            /**
		             * Defines the file if it is not loaded from  File or URI. If not defined, File or URI is used.
		             */
		            public LoadArgumentsBuilder inputStream(final InputStream inputStream) {
		                requireNonNull(inputStream);
		                this.inputStream = inputStream;
		                inputStream$set = true;
		                return this;
		            }
		
		            public LoadArguments build() {
		                URIHandler uriHandler = this.uriHandler;
		                if (!uriHandler$set) uriHandler = LoadArguments.$default$uriHandler();
		                ResourceSet resourceSet = this.resourceSet;
		                if (!resourceSet$set) resourceSet = LoadArguments.$default$resourceSet();
		                String version = this.version;
		                if (!version$set) version = LoadArguments.$default$version();
		                String checksum = this.checksum;
		                if (!checksum$set) checksum = LoadArguments.$default$checksum();
		                String acceptedMetaVersionRange = this.acceptedMetaVersionRange;
		                if (!acceptedMetaVersionRange$set)
		                    acceptedMetaVersionRange = LoadArguments.$default$acceptedMetaVersionRange();
		                Set<String> tags = this.tags;
		                if (!tags$set)
		                    tags = LoadArguments.$default$tags();

		                Map<Object, Object> loadOptions = this.loadOptions;
		                if (!loadOptions$set) loadOptions = LoadArguments.$default$loadOptions();
		                File file = this.file;
		                if (!file$set) file = LoadArguments.$default$file();
		                InputStream inputStream = this.inputStream;
		                if (!inputStream$set) inputStream = LoadArguments.$default$inputStream();
		
		                return new LoadArguments(uri, name, uriHandler, resourceSet, version,
		                        checksum, acceptedMetaVersionRange, loadOptions, validateModel, file, inputStream, tags);
		            }
		
		            @java.lang.Override
		            
		            public java.lang.String toString() {
		                return "«modelName»Model.LoadArguments.LoadArgumentsBuilder(uri=" + this.uri
		                        + ", name=" + this.name
		                        + ", uriHandler=" + this.uriHandler
		                        + ", resourceSet=" + this.resourceSet
		                        + ", version=" + this.version
		                        + ", checksum=" + this.checksum
		                        + ", acceptedMetaVersionRange=" + this.acceptedMetaVersionRange
		                        + ", loadOptions=" + this.loadOptions
		                        + ", validateModel=" + this.validateModel
		                        + ", file=" + this.file
		                        + ", inputStream=" + this.inputStream
		                        + ", tags=" + this.tags
		                        + ")";
		            }
		        }
		
		        
		        public static LoadArgumentsBuilder «modelName.decapitalize»LoadArgumentsBuilder() {
		            return new LoadArgumentsBuilder();
		        }
		
		        
		        private LoadArguments(final URI uri,
		                              final String name,
		                              final URIHandler uriHandler,
		                              final ResourceSet resourceSet,
		                              final String version,
		                              final String checksum,
		                              final String acceptedMetaVersionRange,
		                              final Map<Object, Object> loadOptions,
		                              final boolean validateModel,
		                              final File file,
		                              final InputStream inputStream,
		                              final Set<String> tags) {
		            this.uri = uri;
		            this.name = name;
		            this.uriHandler = uriHandler;
		            this.resourceSet = resourceSet;
		            this.version = version;
		            this.checksum = checksum;
		            this.acceptedMetaVersionRange = acceptedMetaVersionRange;
		            this.loadOptions = loadOptions;
		            this.validateModel = validateModel;
		            this.file = file;
		            this.inputStream = inputStream;
		            this.tags = tags;
		        }
		
		        
		        «modelName»ModelResourceSupport.LoadArguments.LoadArgumentsBuilder
		                    to«modelName»ModelResourceSupportLoadArgumentsBuilder() {
		            «modelName»ModelResourceSupport.LoadArguments.LoadArgumentsBuilder argumentsBuilder =
		                    «modelName»ModelResourceSupport.LoadArguments.«modelName.decapitalize»LoadArgumentsBuilder()
		                            .uri(getUri()
		                                    .orElseGet(() ->
		                                            org.eclipse.emf.common.util.URI.createURI(
		                                                    getName().get() + "-«modelName.decapitalize».model")))
		                            .validateModel(isValidateModel());
		
		            getUriHandler().ifPresent(argumentsBuilder::uriHandler);
		            getResourceSet().ifPresent(argumentsBuilder::resourceSet);
		            getLoadOptions().ifPresent(argumentsBuilder::loadOptions);
		            getFile().ifPresent(argumentsBuilder::file);
		            getInputStream().ifPresent(argumentsBuilder::inputStream);
		
		            return argumentsBuilder;
		        }
		
		
		    }
		
		
		    /**
		     * Arguments for {@link «modelName»Model#save«modelName»Model(SaveArguments)}
		     * It can handle variance of the presented arguments.
		     */
		    public static class SaveArguments {
		        OutputStream outputStream;
		        File file;
		        Map<Object, Object> saveOptions;
		        boolean validateModel;
		
		        private static OutputStream $default$outputStream() {
		            return null;
		        }
		
		        private static File $default$file() {
		            return null;
		        }
		
		        private static Map<Object, Object> $default$saveOptions() {
		            return null;
		        }
		
		        public Optional<OutputStream> getOutputStream() {
		            return ofNullable(outputStream);
		        }
		
		        public Optional<File> getFile() {
		            return ofNullable(file);
		        }
		
		        public Optional<Map<Object, Object>> getSaveOptions() {
		            return ofNullable(saveOptions);
		        }
		
		        public boolean isValidateModel() {
		            return validateModel;
		        }
		
		        /**
		         * Builder for {@link «modelName»Model#save«modelName»Model(SaveArguments)}.
		         */
		        public static class SaveArgumentsBuilder {
		            
		            private boolean outputStream$set;
		            private OutputStream outputStream;
		            
		            private boolean file$set;
		            private File file;
		            
		            private boolean saveOptions$set;
		            private Map<Object, Object> saveOptions;
		
		            private boolean validateModel = true;
		
		            
		            SaveArgumentsBuilder() {
		            }
		
		            
		            public «modelName»ModelResourceSupport.SaveArguments.SaveArgumentsBuilder
		                        to«modelName»ModelResourceSupportSaveArgumentsBuilder() {
		                «modelName»ModelResourceSupport.SaveArguments.SaveArgumentsBuilder argumentsBuilder =
		                        «modelName»ModelResourceSupport.SaveArguments.«modelName.decapitalize»SaveArgumentsBuilder().validateModel(validateModel);
		
		                if (outputStream$set) argumentsBuilder.outputStream(outputStream);
		                if (file$set) argumentsBuilder.file(file);
		                if (saveOptions$set) argumentsBuilder.saveOptions(saveOptions);
		                return argumentsBuilder;
		            }
		
		            
		            /**
		             * Defines {@link OutputStream} which is used by save. Whe it is not defined, file is used.
		             */
		            public SaveArgumentsBuilder outputStream(final OutputStream outputStream) {
		                requireNonNull(outputStream);
		                this.outputStream = outputStream;
		                outputStream$set = true;
		                return this;
		            }
		
		            
		            /**
		             * Defines {@link File} which is used by save. Whe it is not defined the model's
		             * {@link «modelName»Model#uri is used}
		             */
		            public SaveArgumentsBuilder file(File file) {
		                requireNonNull(file);
		                this.file = file;
		                file$set = true;
		                return this;
		            }
		
		            
		            /**
		             * Defines save options. When it is not defined
		             * {@link «modelName»ModelResourceSupport#get«modelName»ModelDefaultSaveOptions()} is used.
		             */
		            public SaveArgumentsBuilder saveOptions(final Map<Object, Object> saveOptions) {
		                requireNonNull(saveOptions);
		                this.saveOptions = saveOptions;
		                saveOptions$set = true;
		                return this;
		            }
		
		            /**
		             * Defines that model validation required or not on save. Default: true
		             */
		            public SaveArgumentsBuilder validateModel(boolean validateModel) {
		                this.validateModel = validateModel;
		                return this;
		            }
		
		            
		            public SaveArguments build() {
		                OutputStream outputStream = this.outputStream;
		                if (!outputStream$set) outputStream = SaveArguments.$default$outputStream();
		                File file = this.file;
		                if (!file$set) file = SaveArguments.$default$file();
		                Map<Object, Object> saveOptions = this.saveOptions;
		                if (!saveOptions$set) saveOptions = SaveArguments.$default$saveOptions();
		                return new SaveArguments(outputStream, file, saveOptions, validateModel);
		            }
		
		            @java.lang.Override
		            
		            public java.lang.String toString() {
		                return "«modelName»Model.SaveArguments.SaveArgumentsBuilder("
		                        + "outputStream=" + this.outputStream
		                        + ", file=" + this.file
		                        + ", saveOptions=" + this.saveOptions
		                        + ")";
		            }
		        }
		
		        
		        public static SaveArgumentsBuilder «modelName.decapitalize»SaveArgumentsBuilder() {
		            return new SaveArgumentsBuilder();
		        }
		
		        
		        public «modelName»ModelResourceSupport.SaveArguments.SaveArgumentsBuilder to«modelName»ModelResourceSupportSaveArgumentsBuilder() {
		            «modelName»ModelResourceSupport.SaveArguments.SaveArgumentsBuilder argumentsBuilder =
		                    «modelName»ModelResourceSupport.SaveArguments.«modelName.decapitalize»SaveArgumentsBuilder().validateModel(validateModel);
		
		            getOutputStream().ifPresent(o -> argumentsBuilder.outputStream(o));
		            getFile().ifPresent(o -> argumentsBuilder.file(o));
		            getSaveOptions().ifPresent(o -> argumentsBuilder.saveOptions(o));
		            return argumentsBuilder;
		        }
		
		
		        
		        private SaveArguments(final OutputStream outputStream,
		                              final File file,
		                              final Map<Object, Object> saveOptions,
		                              final boolean validateModel) {
		            this.outputStream = outputStream;
		            this.file = file;
		            this.saveOptions = saveOptions;
		            this.validateModel = validateModel;
		        }
		    }
		
		
		    
		    public static class «modelName»ModelBuilder {
		        
		        private String name;
		        private URI uri;
		
		        private boolean version$set;
		        private String version;
		
		        private boolean checksum$set;
		        private String checksum;
		
		        private boolean metaVersionRange$set;
		        private String metaVersionRange;

		        private boolean tags$set;
		        private Set<String> tags;
		
		        private boolean «modelName.decapitalize»ModelResourceSupport$set;
		        private «modelName»ModelResourceSupport «modelName.decapitalize»ModelResourceSupport;
		
		        private boolean resourceSet$set;
		        private ResourceSet resourceSet;
		
		        private URIHandler uriHandler;
		        private boolean uriHandler$set;
		
		
		        «modelName»ModelBuilder() {
		        }
		
		        
		        /**
		         * Defines name of the model. Its mandatory.
		         */
		        public «modelName»ModelBuilder name(final String name) {
		            this.name = name;
		            return this;
		        }
		
		        
		        /**
		         * Defines the uri {@link URI} of the model. Its mandatory.
		         */
		        public «modelName»ModelBuilder uri(final URI uri) {
		            this.uri = uri;
		            return this;
		        }
		
		        
		        /**
		         * Defines the version of the model. Its mandatory.
		         */
		        public «modelName»ModelBuilder version(final String version) {
		            requireNonNull(version);
		            this.version = version;
		            version$set = true;
		            return this;
		        }
		
		        
		        /**
		         * Defines the checksum of the model. Its mandatory.
		         */
		        public «modelName»ModelBuilder checksum(final String checksum) {
		            requireNonNull(checksum);
		            this.checksum = checksum;
		            this.checksum$set = true;
		            return this;
		        }
		
		        
		        /**
		         * Defines the version of the model.
		         */
		        public «modelName»ModelBuilder metaVersionRange(final String metaVersionRange) {
		            requireNonNull(metaVersionRange);
		            this.metaVersionRange = metaVersionRange;
		            this.metaVersionRange$set = true;
		            return this;
		        }

		        /**
		         * Defines the tags of the model.
		         */
		        public «modelName»ModelBuilder tags(final Set<String> tags) {
		            requireNonNull(tags);
		            this.tags = tags;
		            this.tags$set = true;
		            return this;
		        }
		
		        
		        public «modelName»ModelBuilder «modelName.decapitalize»ModelResourceSupport(final «modelName»ModelResourceSupport «modelName.decapitalize»ModelResourceSupport) {
		            requireNonNull(«modelName.decapitalize»ModelResourceSupport);
		            this.«modelName.decapitalize»ModelResourceSupport = «modelName.decapitalize»ModelResourceSupport;
		            this.«modelName.decapitalize»ModelResourceSupport$set = true;
		            return this;
		        }
		
		        public «modelName»ModelBuilder resourceSet(final ResourceSet resourceSet) {
		            requireNonNull(resourceSet);
		            this.resourceSet = resourceSet;
		            this.resourceSet$set = true;
		            return this;
		        }
		
		        public «modelName»ModelBuilder uriHandler(final URIHandler uriHandler) {
		            requireNonNull(uriHandler);
		            this.uriHandler = uriHandler;
		            this.uriHandler$set = true;
		            return this;
		        }
		
		
		        public «modelName»Model build() {
		            org.eclipse.emf.common.util.URI uriPhysicalOrLogical = ofNullable(uri)
		                    .orElseGet(() -> org.eclipse.emf.common.util.URI.createURI(name + "-«modelName.decapitalize».model"));
		
		            «modelName»ModelResourceSupport «modelName.decapitalize»ModelResourceSupport = this.«modelName.decapitalize»ModelResourceSupport;
		            if (!«modelName.decapitalize»ModelResourceSupport$set) {
		                «modelName»ModelResourceSupport.«modelName»ModelResourceSupportBuilder «modelName.decapitalize»ModelResourceSupportBuilder =
		                        «modelName»ModelResourceSupport.«modelName.decapitalize»ModelResourceSupportBuilder()
		                                .uri(uriPhysicalOrLogical);
		
		                if (resourceSet$set) «modelName.decapitalize»ModelResourceSupportBuilder.resourceSet(resourceSet);
		                if (uriHandler$set) «modelName.decapitalize»ModelResourceSupportBuilder.uriHandler(uriHandler);
		
		                «modelName.decapitalize»ModelResourceSupport = «modelName.decapitalize»ModelResourceSupportBuilder.build();
		            } else {
		                this.uri = «modelName.decapitalize»ModelResourceSupport.getResource().getURI();
		            }
		
		            String version = this.version;
		            if (!version$set) version = LoadArguments.$default$version();
		            String checksum = this.checksum;
		            if (!checksum$set) checksum = LoadArguments.$default$checksum();
		            String metaVersionRange = this.metaVersionRange;
		            if (!metaVersionRange$set) metaVersionRange = LoadArguments.$default$acceptedMetaVersionRange();
		            Set<String> tags = this.tags;
		            if (!tags$set) tags = LoadArguments.$default$tags();
		
		            return new «modelName»Model(name, version, uriPhysicalOrLogical, checksum, metaVersionRange, tags, «modelName.decapitalize»ModelResourceSupport);
		        }
		
		        @java.lang.Override
		        public java.lang.String toString() {
		            return "«modelName»Model.«modelName»ModelBuilder(name=" + this.name
		                    + ", version=" + this.version
		                    + ", uri=" + this.uri
		                    + ", checksum=" + this.checksum
		                    + ", metaVersionRange=" + this.metaVersionRange
		                    + ", «modelName.decapitalize»ModelResourceSupport=" + this.«modelName.decapitalize»ModelResourceSupport + ")";
		        }
		    }
		
		    public static «modelName»ModelBuilder build«modelName»Model() {
		        return new «modelName»ModelBuilder();
		    }
		
		    private «modelName»Model(final String name,
		                     final String version,
		                     final URI uri,
		                     final String checksum,
		                     final String metaVersionRange,
		                     final Set<String> tags,
		                     final «modelName»ModelResourceSupport «modelName.decapitalize»ModelResourceSupport) {
		
		        requireNonNull(name, "Name is mandatory");
		        requireNonNull(name, "URI is mandatory");
		
		        this.name = name;
		        this.version = version;
		        this.uri = uri;
		        this.checksum = checksum;
		        this.metaVersionRange = metaVersionRange;
		        this.tags = tags;
		        this.«modelName.decapitalize»ModelResourceSupport = «modelName.decapitalize»ModelResourceSupport;
		    }
		
		    @java.lang.Override
		    public java.lang.String toString() {
		        return "«modelName»Model(name=" + this.getName()
		                + ", version=" + this.getVersion()
		                + ", uri=" + this.getUri()
		                + ", checksum=" + this.getChecksum()
		                + ", metaVersionRange=" + this.getMetaVersionRange()
		                + ", tags=" + this.getTags()
		                + ", «modelName.decapitalize»ModelResourceSupport=" + this.«modelName.decapitalize»ModelResourceSupport + ")";
		    }
		
		    /**
		     * Get the name of the model.
		     */
		    public String getName() {
		        return this.name;
		    }
		
		    /**
		     * Get the model version.
		     */
		    public String getVersion() {
		        return this.version;
		    }
		
		    /**
		     * Get the {@link URI} of the model.
		     */
		    public URI getUri() {
		        return this.uri;
		    }
		
		    /**
		     * Get the checksum of the model.
		     */
		    public String getChecksum() {
		        return this.checksum;
		    }
		
		    /**
		     * Get the accepted range of meta model version.
		     */
		    public String getMetaVersionRange() {
		        return this.metaVersionRange;
		    }

		
		    /**
		     * Get the tags.
		     */
		    public Set<String> getTags() {
		        return this.tags;
		    }

		}
	'''
}