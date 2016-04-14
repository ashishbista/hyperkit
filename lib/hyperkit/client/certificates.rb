require 'active_support/core_ext/hash/slice'
require 'base64'

module Hyperkit

  class Client

    # Methods for the certificates API
    module Certificates

      # GET /certificates
      def certificates 
        response = get(certificates_path)
        response.metadata.map { |path| path.split('/').last }
      end

      # POST /certificates
      def create_certificate(cert, options={})
        options = options.slice(:name, :password)
        options = options.merge(type: "client", certificate: Base64.strict_encode64(OpenSSL::X509::Certificate.new(cert).to_der))
        post(certificates_path, options).metadata
      end

      # GET /certificates/<fingerprint>
      def certificate(fingerprint)
        get(certificate_path(fingerprint)).metadata
      end

      # DELETE /certificates/<fingerprint>
      def delete_certificate(fingerprint)
        delete(certificate_path(fingerprint)).metadata
      end

      def certificate_path(fingerprint)
        File.join(certificates_path, fingerprint)
      end

      def certificates_path
        "/1.0/certificates"
      end
    end

  end

end

